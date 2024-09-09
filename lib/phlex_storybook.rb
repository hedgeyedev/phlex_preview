# frozen_string_literal: true

require "importmap-rails"
require "phlex_icons"
require "phlex-rails"
require "phlex"
require "rouge"
require "stimulus-rails"
require "turbo_power"
require "turbo-rails"

require "phlex_storybook/version"
require "phlex_storybook/engine"
require "phlex_storybook/configuration"

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
    autoload :ComponentInitializer, "phlex_storybook/props/component_initializer"
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
