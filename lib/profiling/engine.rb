class Profiler
  module Engine

    def run(*args)
      label = args.find { |a| a.is_a?(String) }
      opts = args.find { |a| a.is_a?(Hash) }
      enabled = opts.nil? ? true : opts[:if]
      return yield unless enabled

      # Create directory
      @dir = File.join(config[:dir], label.to_s)
      FileUtils.mkdir_p(@dir) unless File.exist?(@dir)

      require 'ruby-prof'

      profile = RubyProf::Profile.new

      profile.exclude_methods!(::Profiler::Engine, :run)
      profile.exclude_common_methods! if config[:exclude_standard_lib]
      # Note, we optionally exclude ruby gems after collecting the profile results
      # instead of here as we can't exclude by a path any other way.

      profile.start

      begin
        yield
      rescue => e
        profile.stop
        raise e
      end

      @results = profile.stop

      # Optionally remove gems (and the remainder of any standard lib) from the results
      if !@results.threads.empty? && exclusion_regex
        @results.threads.each do |thread|
          thread.methods.each { |m| m.eliminate! if m.source_file.match(exclusion_regex) }
        end
      end

      out()
    end

    private

    def out
      File.open(File.join(@dir, "graph.html"), 'w') do |file|
        RubyProf::GraphHtmlPrinter.new(@results).print(file)
      end

      File.open(File.join(@dir, "flat.txt"), 'w') do |file|
        RubyProf::FlatPrinterWithLineNumbers.new(@results).print(file)
      end

      File.open(File.join(@dir, "stack.html"), 'w') do |file|
        RubyProf::CallStackPrinter.new(@results).print(file)
      end
    end

    def exclusion_regex
      root = "/lib/ruby/"
      if config[:exclude_gems] && config[:exclude_standard_lib]
        /#{root}/
      elsif config[:exclude_gems]
        /#{root}gems\//
      elsif config[:exclude_standard_lib]
        /#{root}[^g]/
      end
    end

  end
end
