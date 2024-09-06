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
  autoload :DSL, "phlex_storybook/dsl"
  autoload :ApplicationComponent, "phlex_storybook/application_component"
  autoload :ApplicationView, "phlex_storybook/application_view"
  autoload :ComponentStory, "phlex_storybook/component_story"

  module Props
    autoload :Base, "phlex_storybook/props/base"
    autoload :String, "phlex_storybook/props/string"
    autoload :Select, "phlex_storybook/props/select"
    autoload :Text, "phlex_storybook/props/text"
    autoload :Boolean, "phlex_storybook/props/boolean"
  end

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
