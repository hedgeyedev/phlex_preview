require_relative "story_component"

module PhlexStorybook
  class Configuration
    attr_reader :components

    def initialize
      @components = {}
    end

    def editable?
      Rails.env.development?
    end

    def register(component, location)
      @components[component] = StoryComponent.new(component, location: location)
    end
  end
end
