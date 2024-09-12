# frozen_string_literal: true

require_relative "story_component"

module PhlexStorybook
  class Configuration
    attr_reader :components

    def initialize
      @components = Concurrent::Hash.new
      @component_paths = Set.new
      @lock = Concurrent::ReentrantReadWriteLock.new
    end

    def add_component_path(path)
      @component_paths << path
      rescan!
    end

    def components
      c = {}
      @lock.with_read_lock { @components.each { |k, v| c[k] = v } }
      c
    end

    def editable?
      Rails.env.development?
    end

    def register(component, location)
      @lock.with_write_lock do
        @components[component] = StoryComponent.new(component, location: location)
      end
    end

    def rescan!
      @lock.with_write_lock do
        @components.clear
        @component_paths.each do |path|
          Dir[Rails.root.join(path, "**/*.rb").to_s].each do |file|
            load file
          rescue StandardError => e
            Rails.logger.error "Error scanning #{file}: #{e.message}"
          end
        end
      end
    end
  end
end
