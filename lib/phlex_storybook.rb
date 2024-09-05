# frozen_string_literal: true

require "phlex_storybook/version"
require "phlex_storybook/engine"
require "phlex_storybook/configuration"

# require "zeitwerk"

# loader = Zeitwerk::Loader.new
# loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
# loader.push_dir(File.expand_path("../app", __dir__))
# loader.setup

module PhlexStorybook
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end
end
