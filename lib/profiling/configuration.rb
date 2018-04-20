class Profiler
  module Configuration

    DEFAULT_CONFIG = {
      dir: 'profiling',
      exclude_gems: true
    }

    attr_accessor :config

    def self.extended(mod)
      mod.config = DEFAULT_CONFIG
    end

    def configure(opts)
      self.config = DEFAULT_CONFIG.merge(opts)
    end
  end
end
