RSpec.describe Profile do

  before do
    Profile.configure(Profile::Configuration::DEFAULT_CONFIG)
  end

  describe "Configuration" do

    it "should provide a default output dir" do
      expect(Profile.config[:dir]).to eq 'profiled'
    end

    it "should allow you to specific a dir" do
      Profile.configure(dir: 'my-dir')
      expect(Profile.config[:dir]).to eq 'my-dir'
    end

  end

  describe "#run" do

    before do
      allow(RubyProf).to receive(:start).and_return(true)
      allow(RubyProf).to receive(:stop).and_return(true)
      allow_any_instance_of(RubyProf::GraphHtmlPrinter).to receive(:print).and_return(nil)
      allow_any_instance_of(RubyProf::FlatPrinterWithLineNumbers).to receive(:print).and_return(nil)
      allow_any_instance_of(RubyProf::CallStackPrinter).to receive(:print).and_return(nil)
    end

    path = File.join(File.dirname(__FILE__), "../lib/profiled")

    after do
      FileUtils.rm_rf(path)
    end

    it "should create correct directories based on label" do
      Profile.run("my/label") { 1 * 1}
      expect(File.exist?(File.join(path, "my/label"))).to be true
    end

    it "should write the correct files" do
      Profile.run("file-test") { 1 * 1}
      ['graph.html', 'stack.html', 'flat.txt'].each do |file|
        expect(File.exist?(File.join(path, "file-test/#{file}"))).to be true
      end
    end

    it "should disable profiling when if: false" do
      expect(RubyProf).not_to receive(:start)
      Profile.run("file-test", if: false) { 1 * 1}
    end

    it "should enable profiling when if: true" do
      expect(RubyProf).to receive(:start)
      Profile.run("file-test", if: true) { 1 * 1}
    end

    it "should stop ruby-prof when code being profile encounters an exception" do
      expect(RubyProf).to receive(:stop)
      expect{Profile.run("file-test", if: true) do raise StandardError end}.to raise_exception(StandardError)
    end

  end

end
