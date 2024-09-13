# frozen_string_literal: true

require "fileutils"
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

    def create_experiment!(name)
      ensure_experiments_directory!
      File.write(File.join(experiments_directory, "#{name.demodulize.underscore}.rb"), experiment_template(name))
    end

    def experiment(name)
      experiments.detect { |e| e.end_with?("#{name}.rb") }
    end

    def experiment_template(name)
      file = Engine.root.join("lib", "phlex_storybook", "tasks", "sample_component.rb")
      File.read(file).gsub("SampleComponent", name.split("::").map(&:classify).join("::"))
    end

    def experiments
      ensure_experiments_directory!
      Dir[File.join(experiments_directory, "*.rb")]
    end

    def experiments_directory
      Rails.root.join("tmp", "experiments")
    end

    private

    def ensure_experiments_directory!
      FileUtils.mkdir_p(experiments_directory)
    end
  end
end
