module PhlexStorybook
  class StoryComponent
    attr_reader :component
    attr_accessor :category, :description, :location, :name, :props, :stories
    alias to_param name

    def initialize(component, location: nil)
      @component   = component
      @location    = location || nil #component.source_location
      @name        = component.name
      @category    = "Uncategorized"
      @description = "No description provided"
      @props       = []
      @stories     = {}
    end

    def default_story
      props
        .select { |prop| prop.required }
        .map { |prop| [prop.key, prop.default || prop.class.default] }
        .to_h
    end

    def id_for(title)
      Digest::MD5.hexdigest(title)
    end

    def source
      File.read component.instance_method(:view_template).source_location.first
    end

    def story_for(id)
      stories.detect { |key, props| id_for(key) == id }&.last
    end

    def transform_props(user_data)
      return user_data if user_data.blank?

      user_data.map.with_object({}) do |(k, v), h|
        h[k] = props.detect { |prop| prop.key == k }&.transform(v)
      end.compact
    end
  end
end
