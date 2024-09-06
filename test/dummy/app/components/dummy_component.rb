# frozen_string_literal: true

class DummyComponent < Phlex::HTML
  include PhlexStorybook::DSL

  register_component do
    component_category "Category 1"
    component_description "This is a dummy component"
    component_name "Dummy Component"
  end

  def view_template
    h1 { "The Title" }
    ul do
      %w[Story1 Story2 Story3].each do |story|
        li { story }
      end
    end
  end
end
