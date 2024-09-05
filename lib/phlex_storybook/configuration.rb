module PhlexStorybook
  class Configuration
    attr_accessor :component_directories

    def initialize
      @component_directories = %w[app/components]
    end

    def components
      component_directories.flat_map do |dir|
        Dir.glob("#{dir}/**/*.rb").select { |f| File.file?(f) }.map do |file|
          StoryComponent.new File.basename(file, ".rb").camelize.constantize, file
        end
      end
    end

    def component_directories
      @component_directories.map { |dir| Rails.root.join dir }
    end

    def component_directories=(directories)
      @component_directories = directories
    end
  end
end
