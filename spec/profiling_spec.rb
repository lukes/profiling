RSpec.describe  do

  before do
    Profiler.configure(Profiler::Configuration::DEFAULT_CONFIG)
  end

  describe "Configuration" do

    it "should provide a default output dir" do
      expect(Profiler.config[:dir]).to eq 'profiling'
    end

    it "should allow you to specific a dir" do
      Profiler.configure(dir: 'my-dir')
      expect(Profiler.config[:dir]).to eq 'my-dir'
    end

  end

  describe "#run" do

    before do
      @path = File.join(File.dirname(__FILE__), "tmp/profiling")
      Profiler.configure(dir: @path)

      allow_any_instance_of(RubyProf::Profile).to receive(:start).and_return(true)
      allow_any_instance_of(RubyProf::Profile).to receive(:stop).and_return(true)
      allow_any_instance_of(RubyProf::GraphHtmlPrinter).to receive(:print).and_return(nil)
      allow_any_instance_of(RubyProf::FlatPrinterWithLineNumbers).to receive(:print).and_return(nil)
      allow_any_instance_of(RubyProf::CallStackPrinter).to receive(:print).and_return(nil)
    end

    after do
      FileUtils.rm_rf(@path)
    end

    it "should create correct directories" do
      Profiler.run { 1 * 1 }
      expect(File.exist?(File.join(@path))).to be true
    end

    it "should create correct directories based on label" do
      Profiler.run("my/label") { 1 * 1 }
      expect(File.exist?(File.join(@path, "my/label"))).to be true
    end

    it "should write the correct files" do
      Profiler.run("file-test") { 1 * 1 }
      ['graph.html', 'stack.html', 'flat.txt'].each do |file|
        expect(File.exist?(File.join(@path, "file-test/#{file}"))).to be true
      end
    end

    it "should disable profiling when if: false" do
      expect_any_instance_of(RubyProf::Profile).not_to receive(:start)
      Profiler.run("file-test", if: false) { 1 * 1 }
    end

    it "should enable profiling when if: true" do
      expect_any_instance_of(RubyProf::Profile).to receive(:start)
      Profiler.run("file-test", if: true) { 1 * 1 }
    end

    it "should stop ruby-prof when code being profile encounters an exception" do
      expect_any_instance_of(RubyProf::Profile).to receive(:stop)
      expect{Profiler.run("file-test", if: true) do raise StandardError end}.to raise_exception(StandardError)
    end

  end

end
