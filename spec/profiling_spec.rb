RSpec.describe Profiling do

  before do
    Profiling.configure(Profiling::Configuration::DEFAULT_CONFIG)
  end

  describe "Configuration" do

    it "should provide a default output dir" do
      expect(Profiling.config[:dir]).to eq 'profiling'
    end

    it "should allow you to specific a dir" do
      Profiling.configure(dir: 'my-dir')
      expect(Profiling.config[:dir]).to eq 'my-dir'
    end

  end

  describe "#run" do

    before do
      @path = File.join(File.dirname(__FILE__), "tmp/profiling")
      Profiling.configure(dir: @path)

      allow(RubyProf).to receive(:start).and_return(true)
      allow(RubyProf).to receive(:stop).and_return(true)
      allow_any_instance_of(RubyProf::GraphHtmlPrinter).to receive(:print).and_return(nil)
      allow_any_instance_of(RubyProf::FlatPrinterWithLineNumbers).to receive(:print).and_return(nil)
      allow_any_instance_of(RubyProf::CallStackPrinter).to receive(:print).and_return(nil)
    end

    after do
      FileUtils.rm_rf(@path)
    end

    it "should create correct directories based on label" do
      Profiling.run("my/label") { 1 * 1}
      expect(File.exist?(File.join(@path, "my/label"))).to be true
    end

    it "should write the correct files" do
      Profiling.run("file-test") { 1 * 1}
      ['graph.html', 'stack.html', 'flat.txt'].each do |file|
        expect(File.exist?(File.join(@path, "file-test/#{file}"))).to be true
      end
    end

    it "should disable profiling when if: false" do
      expect(RubyProf).not_to receive(:start)
      Profiling.run("file-test", if: false) { 1 * 1}
    end

    it "should enable profiling when if: true" do
      expect(RubyProf).to receive(:start)
      Profiling.run("file-test", if: true) { 1 * 1}
    end

    it "should stop ruby-prof when code being profile encounters an exception" do
      expect(RubyProf).to receive(:stop)
      expect{Profiling.run("file-test", if: true) do raise StandardError end}.to raise_exception(StandardError)
    end

  end

end
