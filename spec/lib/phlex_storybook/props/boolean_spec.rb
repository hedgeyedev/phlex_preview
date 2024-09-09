# frozen_string_literal: true

describe PhlexStorybook::Props::Boolean do
  subject(:prop) { PhlexStorybook::Props::Boolean.new(key: 'foo') }

  describe "#transform" do
    shared_examples_for 'a boolean' do |value, expected_value|
      it { expect(prop.transform(value)).to eq(expected_value) }
    end

    it_behaves_like "a boolean", true, true
    it_behaves_like "a boolean", false, false
    it_behaves_like "a boolean", '1', true
    it_behaves_like "a boolean", '0', false
    it_behaves_like "a boolean", %w[0], false
    it_behaves_like "a boolean", %w[1], true
    it_behaves_like "a boolean", %w[0 0], false
    it_behaves_like "a boolean", %w[0 1], true
    it_behaves_like "a boolean", %w[1 0], true
    it_behaves_like "a boolean", %w[1 1], true
    it_behaves_like "a boolean", 'foo', false
  end
end
