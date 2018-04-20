class Profiler
  module Engine

    def run(label=nil, options={})
      enabled = options[:if].nil? ? true : !!options[:if]
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

      # Optionally remove gems from the results
      if !@results.threads.empty? && config[:exclude_gems]
        @results.threads.map! do |thread|
          thread.methods.reject!{ |m| m.source_file.match(/\/gems\//) }
          thread
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

  end
end
