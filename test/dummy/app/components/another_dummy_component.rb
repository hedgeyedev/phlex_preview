# frozen_string_literal: true

class AnotherDummyComponent < Phlex::HTML
  def self.component_category
    "Category 2"
  end

  def self.component_description
    <<~TEXT
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      Morbi hendrerit libero euismod nisl venenatis sollicitudin.
      Curabitur in leo vel justo vulputate ornare at id dolor.
      Curabitur at diam quis orci efficitur ullamcorper.
      Nullam posuere mauris eget elit blandit dapibus sit amet id purus.
      Phasellus eleifend ante sit amet lacus tristique, sed sodales nisl porttitor.
      Nullam mollis nisi non magna tincidunt, quis ullamcorper odio suscipit.
      Sed pretium ligula ut mi ullamcorper eleifend.
      Pellentesque eget metus a lorem feugiat feugiat eget sed nunc.
      Aenean blandit urna non tortor gravida viverra.
      Aenean quis nunc pulvinar, lacinia metus non, lacinia lorem.
      Nullam nec magna id ante venenatis gravida.
      Mauris vestibulum metus ut erat feugiat, sit amet cursus lectus commodo.
      Donec elementum purus consectetur leo pharetra finibus.
      Duis viverra odio eget posuere varius.
      Integer tristique odio ac diam porttitor, id maximus lacus ultricies.
      Donec semper neque eget leo gravida malesuada.
      Ut non tortor nec ipsum euismod dignissim in suscipit leo.
      Sed imperdiet risus sit amet mi rutrum luctus.
    TEXT
  end

  def self.component_props
    [
      PhlexStorybook::Props::String.new(key: :header, placeholder: "The header", required: true),
      PhlexStorybook::Props::Text.new(key: :text, label: "The list"),
      PhlexStorybook::Props::Boolean.new(key: :truthy, label: "Truthy"),
      PhlexStorybook::Props::Select.new(key: :selectable, label: "Select", include_blank: true, options: %w[Option1 Option2 Option3]),
      PhlexStorybook::Props::Select.new(key: :multi_selectable, label: "Select Several", multiple: true, options: %w[Option1 Option2 Option3]),
    ]
  end

  def self.component_stories
    [
      { title: "Short List", header: "Candidates", text: short_string, truthy: true },
      { title: "Still Deciding", header: "Things", text: long_string, truthy: false },
    ]
  end

  def self.long_string
    100.times.map { |i| "list item #{i + 1}" }.join("\n")
  end

  def self.short_string
    3.times.map { |i| "Candidate #{i + 1}" }.join("\n")
  end

  def initialize(header:, text: "", truthy: false, selectable: [], multi_selectable: [])
    @text             = text
    @header           = header
    @multi_selectable = multi_selectable
    @selectable       = selectable
    @truthy           = truthy
  end

  def view_template
    h1 { @header }
    pre(class: "border border-slate-700 p-2") { @text }
    div { @truthy ? "This is true" : "This is false" }
    div { @selectable }
    ul do
      @multi_selectable.each do |option|
        li { option }
      end
    end
  end
end
