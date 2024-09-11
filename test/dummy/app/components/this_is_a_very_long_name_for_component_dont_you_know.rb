class ThisIsAVeryLongNameForComponentDontYouKnow < Phlex::HTML
  include Phlex::Rails::Layout
  include Phlex::Rails::Helpers::CSRFMetaTags
  include Phlex::Rails::Helpers::CSPMetaTag

  include PhlexStorybook::DSL

  storybook do
    category "Category 2"
    prop_text 0, required: true, default: "This is a long text - #{"x" * 13}"
    story "This is a long story name - #{"x" * 13}", "not too long here"
  end

  def initialize(text)
    @text = text
  end

  def view_template(&)
    h1 { "Hello World" }
    p { @text }
  end
end
