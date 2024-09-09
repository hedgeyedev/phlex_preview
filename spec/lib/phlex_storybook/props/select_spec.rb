# frozen_string_literal: true

describe PhlexStorybook::Props::Select do
  describe "#name" do
    subject(:prop) { PhlexStorybook::Props::Select.new(key: 'foo', options: %w[ant bat cat], multiple: multiple) }

    context "single select" do
      let(:multiple) { false }

      it { expect(prop.name).to eq('props[foo]') }
    end

    context "multi select" do
      let(:multiple) { true }

      it { expect(prop.name).to eq('props[foo][]') }
    end
  end
end
