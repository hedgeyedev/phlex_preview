# frozen_string_literal: true

describe PhlexStorybook::Props::ComponentInitializer do
  class TestComponent
    include PhlexStorybook::DSL

    attr_reader :a, :b, :c, :d, :maybe

    storybook do
      prop_string 0
      prop_text 3
      prop_boolean :maybe
    end

    def initialize(a, b, c, d, maybe:)
      @a, @b, @c, @d = a, b, c, d
      @maybe         = maybe
    end
  end

  let(:story_component)       { PhlexStorybook.configuration.components[TestComponent] }
  let(:args)                  { { "0" => "zero", "3" => "three", maybe: true } }
  let(:component_initializer) { PhlexStorybook::Props::ComponentInitializer.create(story_component, **args) }

  it 'should initialize a component' do
    component = component_initializer.initialize_component(TestComponent)
    expect(component.a).to eq "zero"
    expect(component.b).to be_nil
    expect(component.c).to be_nil
    expect(component.d).to eq "three"
    expect(component.maybe).to be true
  end

  describe "#parameters_as_string" do
    context "without params" do
      subject { PhlexStorybook::Props::ComponentInitializer.new.parameters_as_string }

      it { is_expected.to be_empty }
    end

    context "with params" do
      subject do
        PhlexStorybook::Props::ComponentInitializer.new.tap do |ci|
          ci.positional_arguments << 'foo'
          ci.keyword_arguments[:bar] = 'baz'
        end.parameters_as_string
      end

      it { is_expected.to eq("\n  \"foo\",\n  bar: \"baz\",") }
    end
  end
end
