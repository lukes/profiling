require 'fileutils'
require 'ostruct'

Dir[File.dirname(__FILE__) + '/profile/*.rb'].each { |file| require file }

class Profile
  extend Configuration

  def self.run(label=nil, options={})
    enabled = options[:if].nil? ? true : !!options[:if]

    return yield unless enabled

    label ||= ''

    # Create directories
    subdir = File.join(File.dirname(__FILE__), config[:dir], label)
    FileUtils.mkdir_p subdir unless File.exist? subdir

    require 'ruby-prof'

    RubyProf.start

    begin
      yield
    rescue => e
      RubyProf.stop
      raise e
    end

    results = RubyProf.stop

    File.open(File.join(subdir, "graph.html"), 'w') do |file|
      RubyProf::GraphHtmlPrinter.new(results).print(file)
    end

    File.open(File.join(subdir, "flat.txt"), 'w') do |file|
      RubyProf::FlatPrinterWithLineNumbers.new(results).print(file)
    end

    File.open(File.join(subdir, "stack.html"), 'w') do |file|
      RubyProf::CallStackPrinter.new(results).print(file)
    end
  end

end
