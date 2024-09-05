module PhlexStorybook
  class StoryComponent
    attr_reader :component, :location

    def initialize(component, location)
      @component = component
      @location  = location
    end

    def component_category
      component.respond_to?(:component_category) ? component.component_category : "Uncategorized"
    end

    def component_description
      component.respond_to?(:component_description) ? component.component_description : "No description provided"
    end

    def component_name
      component.respond_to?(:component_name) ? component.component_name : component.name
    end
    alias to_param component_name

    def component_props
      component.respond_to?(:component_props) ? component.component_props : []
    end

    def component_stories
      component.respond_to?(:component_stories) ? component.component_stories : []
    end

    def default_story
      component_props
        .select { |prop| prop.required }
        .map { |prop| [prop.key, prop.default || prop.class.default] }
        .to_h
    end

    def default_string = ""
    def default_string_list = []

    def id_for(title)
      Digest::MD5.hexdigest(title)
    end

    def story_for(id)
      component_stories.detect { |props| id_for(props[:title]) == id }
    end

    def transform_props(props)
      return props if component_props.blank?

      props.map.with_object({}) do |(k, v), h|
        h[k] = component_props.detect { |prop| prop.key == k }&.transform(v)
      end.compact
    end
  end
end
