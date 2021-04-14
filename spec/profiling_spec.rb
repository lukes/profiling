# frozen_string_literal: true

RSpec.describe do
  before do
    # Reset configuration
    Profiler.configure(Profiler::Configuration::DEFAULT_CONFIG)
  end

  describe 'Configuration' do
    it 'should provide a default output dir' do
      expect(Profiler.config[:dir]).to eq 'profiling'
    end

    it 'should allow you to specific a dir' do
      Profiler.configure(dir: 'my-dir')
      expect(Profiler.config[:dir]).to eq 'my-dir'
    end

    it 'should not exclude ruby gems by default' do
      expect(Profiler.config[:exclude_gems]).to be false
    end

    it 'should allow you to exclude ruby gems' do
      Profiler.configure(exclude_gems: true)
      expect(Profiler.config[:exclude_gems]).to be true
    end

    it 'should not exclude standard library files by default' do
      expect(Profiler.config[:exclude_standard_lib]).to be false
    end

    it 'should allow you to exclude standard library files' do
      Profiler.configure(exclude_standard_lib: true)
      expect(Profiler.config[:exclude_standard_lib]).to be true
    end
  end

  describe '#run' do
    before do
      @path = File.join(File.dirname(__FILE__), 'tmp/profiling')
      Profiler.configure(dir: @path)

      allow_any_instance_of(RubyProf::Profile).to receive(:start).and_return(true)
      allow_any_instance_of(RubyProf::Profile).to receive(:stop).and_return(OpenStruct.new(threads: []))
      allow_any_instance_of(RubyProf::GraphHtmlPrinter).to receive(:print).and_return(nil)
      allow_any_instance_of(RubyProf::FlatPrinter).to receive(:print).and_return(nil)
      allow_any_instance_of(RubyProf::CallStackPrinter).to receive(:print).and_return(nil)
    end

    after do
      FileUtils.rm_rf(@path)
    end

    it 'should create correct directories' do
      Profiler.run { 1 * 1 }
      expect(File.exist?(File.join(@path))).to be true
    end

    it 'should create correct directories based on label' do
      Profiler.run('my/label') { 1 * 1 }
      expect(File.exist?(File.join(@path, 'my/label'))).to be true
    end

    it 'should write the correct files' do
      Profiler.run('file-test') { 1 * 1 }
      ['graph.html', 'stack.html', 'flat.txt'].each do |file|
        expect(File.exist?(File.join(@path, "file-test/#{file}"))).to be true
      end
    end

    it 'should disable profiling when if: false' do
      expect_any_instance_of(RubyProf::Profile).not_to receive(:start)
      Profiler.run(if: false) { 1 * 1 }
    end

    it 'should enable profiling when if: true' do
      expect_any_instance_of(RubyProf::Profile).to receive(:start)
      Profiler.run(if: true) { 1 * 1 }
    end

    it 'should allow a label and conditional profiling' do
      expect_any_instance_of(RubyProf::Profile).not_to receive(:start)
      Profiler.run('my-label', if: false) { 1 * 1 }
    end

    it 'should stop ruby-prof when code being profile encounters an exception' do
      expect_any_instance_of(RubyProf::Profile).to receive(:stop)
      expect { Profiler.run { raise StandardError } }.to raise_exception(StandardError)
    end

    describe 'eliminating' do
      describe 'gems' do
        before do
          @mock_method_instance = double(source_file: '/lib/ruby/gems/fake_gem.rb')
          mock_result = double(threads: [double(methods: [@mock_method_instance])])
          expect_any_instance_of(RubyProf::Profile).to receive(:stop).and_return(mock_result)
        end

        it 'should eliminate gem methods if config[:exclude_gems] is true' do
          Profiler.configure(exclude_gems: true)
          expect(@mock_method_instance).to receive(:eliminate!)

          Profiler.run { 1 * 1 }
        end

        it 'should not eliminate gem methods if config[:exclude_gems] is false' do
          Profiler.configure(exclude_gems: false)
          expect(@mock_method_instance).not_to receive(:eliminate!)

          Profiler.run { 1 * 1 }
        end
      end

      describe 'standard lib' do
        before do
          @mock_method_instance = double(source_file: '/lib/ruby/2.0.0')
          mock_result = double(threads: [double(methods: [@mock_method_instance])])
          expect_any_instance_of(RubyProf::Profile).to receive(:stop).and_return(mock_result)
        end

        it 'should eliminate standard library methods if config[:exclude_standard_lib] is true' do
          Profiler.configure(exclude_standard_lib: true)

          expect_any_instance_of(RubyProf::Profile).to receive(:exclude_common_methods!)
          expect(@mock_method_instance).to receive(:eliminate!)

          Profiler.run('file-test') { 1 * 1 }
        end

        it 'should not eliminate standard library methods if config[:exclude_standard_lib] is false' do
          Profiler.configure(exclude_standard_lib: false)

          expect_any_instance_of(RubyProf::Profile).not_to receive(:exclude_common_methods!)
          expect(@mock_method_instance).not_to receive(:eliminate!)

          Profiler.run('file-test') { 1 * 1 }
        end
      end
    end
  end
end
