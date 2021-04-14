# frozen_string_literal: true

require 'fileutils'
require 'ostruct'

Dir["#{File.dirname(__FILE__)}/profiling/*.rb"].each { |file| require file }

class Profiler
  extend Configuration
  extend Engine
end
