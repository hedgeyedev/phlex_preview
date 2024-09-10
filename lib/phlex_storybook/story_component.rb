module PhlexStorybook
  class StoryComponent
    attr_reader :component
    attr_accessor :category, :description, :location, :name, :props, :stories
    alias to_param name

    def initialize(component, location: nil)
      @component   = component
      @location    = location || nil #component.source_location
      @filename    = nil
      @name        = component.name
      @category    = "Uncategorized"
      @description = "No description provided"
      @props       = []
      @stories     = {}
    end

    def default_story
      props
        .select { |prop| prop.required }
        .map { |prop| [prop.hash_key, prop.default || prop.class.default] }
        .to_h
    end

    def evaluate!(**props)
      initializer = PhlexStorybook::Props::ComponentInitializer.create(self, **props)
      args = props.blank? ? "" : "(#{initializer.parameters_as_string}\n)"
      source = "render #{component.name}.new#{args}".strip
      [initializer.initialize_component(component), source]
    end

    def id_for(title)
      Digest::MD5.hexdigest(title)
    end

    def source
      File.read filename
    end

    def story_for(id)
      stories.detect { |key, _| id_for(key) == id }&.last
    end

    def transform_props(user_data)
      return user_data if user_data.blank?

      user_data.map.with_object({}) do |(k, v), h|
        h[k] = props.detect { |prop| prop.prop_for?(k) }&.transform(v)
      end.compact
    end

    def update_source(new_source)
      # component.class_eval new_source
      bytes = File.write(filename, new_source)
      load filename
      {success: true, bytes: bytes}
    rescue StandardError => e
      {success: false, error: e}
    end

    private

    def filename
      @filename = component.instance_method(:view_template).source_location.first
    end
  end
end
