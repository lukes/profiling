class Profiler

  module Engine

    def run(label=nil, options={})
      enabled = options[:if].nil? ? true : !!options[:if]
      return yield unless enabled

      # Create directory
      dir = File.join(config[:dir], label.to_s)
      FileUtils.mkdir_p(dir) unless File.exist?(dir)

      require 'ruby-prof'

      RubyProf.start

      begin
        yield
      rescue => e
        RubyProf.stop
        raise e
      end

      results = RubyProf.stop

      File.open(File.join(dir, "graph.html"), 'w') do |file|
        RubyProf::GraphHtmlPrinter.new(results).print(file)
      end

      File.open(File.join(dir, "flat.txt"), 'w') do |file|
        RubyProf::FlatPrinterWithLineNumbers.new(results).print(file)
      end

      File.open(File.join(dir, "stack.html"), 'w') do |file|
        RubyProf::CallStackPrinter.new(results).print(file)
      end
    end

  end
end
