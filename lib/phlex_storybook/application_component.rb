# frozen_string_literal: true

module PhlexStorybook
  class ApplicationComponent < Phlex::HTML
    include Phlex::Rails::Helpers::Routes
    include Phlex::Rails::Helpers::TurboFrameTag

    if Rails.env.development?
      def before_template
        # comment { "Before #{self.class.name}" }
        super
      end
    end
  end
end
