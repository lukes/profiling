require "profile/version"
require 'ostruct'

module Profile

  @@dir = nil
  @@preserve = false

  def self.configure(opts)
    options = OpenStruct.new(opts)

    @@dir = options.dir || 'profiler'
    @@preserve = options.preserve || false
  end

  def self.this(file_name=nil, enabled=true)
    return yield unless enabled

    file_name ||= ''

    # Create dir automatically
    FileUtils.mkdir_p @@dir unless File.exist? @@dir

    require 'ruby-prof'

    RubyProf.start

    begin
      yield
    rescue => e
      RubyProf.stop
      raise e
    end

    results = RubyProf.stop

    subdir = File.join(@@dir, "#{file_name}-#{Time.now.to_i}")
    FileUtils.mkdir_p subdir unless File.exist? subdir

    # Print a flat profile to text
    File.open(File.join(subdir, "graph.html"), 'w') do |file|
      RubyProf::GraphHtmlPrinter.new(results).print(file)
    end

    File.open(File.join(subdir, "flat.txt"), 'w') do |file|
      # RubyProf::FlatPrinter.new(results).print(file)
      RubyProf::FlatPrinterWithLineNumbers.new(results).print(file)
    end

    File.open(File.join(subdir, "stack.html"), 'w') do |file|
      RubyProf::CallStackPrinter.new(results).print(file)
    end
  end

end
