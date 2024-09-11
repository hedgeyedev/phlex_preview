# frozen_string_literal: true

describe PhlexStorybook::DSL do
  class TestComponentOne < Phlex::HTML
    include PhlexStorybook::DSL

    storybook do
      description 'This is a test component'
      category 'Test'
      prop_boolean :bool, default: true
      prop_string :str, label: 'String'
      prop_text :txt
      prop_select :single_select, options: %w[baz blat], required: true, label: 'SS', include_blank: true
      prop_select :multiple_select, multiple: true, options: %w[foo bar], default: %w[foo]
      story 'Bar', single_select: 'blat'
      story 'Baz', single_select: 'baz', multiple_select: %w[foo]
    end

    def initialize(bool:, str:, txt:, single_select:, multiple_select:)
      @str = str
    end

    def view_template
      div
    end
  end

  class TestComponentTwo < Phlex::HTML
    include PhlexStorybook::DSL

    storybook

    def view_template
      div { "testing" }
    end
  end

  let(:comp_one) { PhlexStorybook.configuration.components[TestComponentOne] }
  let(:comp_two) { PhlexStorybook.configuration.components[TestComponentTwo] }

  it 'registers the component' do
    expect(comp_one).to be_a(PhlexStorybook::StoryComponent)
    expect(comp_two).to be_a(PhlexStorybook::StoryComponent)
  end

  it 'registers the component with the correct name' do
    expect(comp_one.name).to eq('TestComponentOne')
    expect(comp_two.name).to eq('TestComponentTwo')
  end

  it 'registers the component with the correct description' do
    expect(comp_one.description).to eq('This is a test component')
    expect(comp_two.description).to eq('No description provided')
  end

  it 'registers the component with the correct category' do
    expect(comp_one.category).to eq('Test')
    expect(comp_two.category).to eq('Uncategorized')
  end

  it 'registers the component with the correct stories' do
    expect(comp_one.stories.keys).to eq(%w[Bar Baz])
    expect(comp_two.stories.keys).to be_empty
  end

  it 'registers the component with the correct props' do
    aggregate_failures do
      expect(comp_one.props.map(&:key)).to(
        eq(%i[bool str txt single_select multiple_select])
      )
      expect(comp_one.props.map(&:label)).to(
        eq(['Bool', 'String', 'Txt', 'SS', 'Multiple Select'])
      )
      expect(comp_one.props.map(&:required)).to eq([false, false, false, true, false])
      expect(comp_one.props.first.default).to eq(true)
      expect(comp_one.props.last.default).to eq(%w[foo])
      expect(comp_one.props[-2..-1].map(&:multiple)).to eq([false, true])
      expect(comp_one.props[-2..-1].map(&:include_blank)).to eq([true, false])

      expect(comp_two.props).to be_empty
    end
  end
end
