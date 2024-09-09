# frozen_string_literal: true

describe PhlexStorybook::Props::Base do
  describe '#new' do
    it 'should initialize with a key' do
      prop = PhlexStorybook::Props::Base.new(key: :foo)
      expect(prop.key).to eq(:foo)
    end

    it 'should initialize with a position' do
      prop = PhlexStorybook::Props::Base.new(position: 1)
      expect(prop.position).to eq(1)
    end
  end

  describe "#clone_with_value" do
    it 'should clone keyword prop with value' do
      prop  = PhlexStorybook::Props::Base.new(key: :foo)
      prop2 = prop.clone_with_value('key_foo')
      expect(prop2.value).to eq('key_foo')
    end

    it 'should clone positional prop with value' do
      prop  = PhlexStorybook::Props::Base.new(position: 2)
      prop2 = prop.clone_with_value('two')
      expect(prop2.value).to eq('two')
    end
  end

  describe "#hash_key" do
    it 'should return symbolized key for keyword prop' do
      prop = PhlexStorybook::Props::Base.new(key: 'foo')
      expect(prop.hash_key).to eq(:foo)
    end

    it 'should return integer position for positional prop' do
      prop = PhlexStorybook::Props::Base.new(position: 2)
      expect(prop.hash_key).to eq(2)
    end
  end

  describe "#keyword?" do
    it 'should return true for keyword prop' do
      prop = PhlexStorybook::Props::Base.new(key: :foo)
      expect(prop).to be_keyword
    end

    it 'should return false for positional prop' do
      prop = PhlexStorybook::Props::Base.new(position: 2)
      expect(prop).not_to be_keyword
    end
  end

  describe "positional?" do
    it 'should return false for keyword prop' do
      prop = PhlexStorybook::Props::Base.new(key: :foo)
      expect(prop).not_to be_positional
    end

    it 'should return true for positional prop' do
      prop = PhlexStorybook::Props::Base.new(position: 2)
      expect(prop).to be_positional
    end
  end

  describe "#prop_for?" do
    it 'should return true for keyword prop' do
      prop = PhlexStorybook::Props::Base.new(key: 'foo')
      expect(prop.prop_for?('foo')).to be true
      expect(prop.prop_for?(:foo)).to be true
      expect(prop.prop_for?(0)).to be false
    end

    it 'should return true for positional prop' do
      prop = PhlexStorybook::Props::Base.new(position: 1)
      expect(prop.prop_for?(0)).to be false
      expect(prop.prop_for?(1)).to be true
      expect(prop.prop_for?(15)).to be false
    end
  end

  describe "#transform" do
    it 'should transform value without a default' do
      prop = PhlexStorybook::Props::Base.new(key: 'foo')
      aggregate_failures do
        expect(prop.transform('')).to be_nil
        expect(prop.transform(nil)).to be_nil
        expect(prop.transform('foo')).to eq('foo')
        expect(prop.transform(true)).to be true
        expect(prop.transform(false)).to be false
      end
    end

    it 'should transform value with a default' do
      prop = PhlexStorybook::Props::Base.new(position: 42, default: 'bar')
      aggregate_failures do
        expect(prop.transform('')).to eq('bar')
        expect(prop.transform(nil)).to eq('bar')
        expect(prop.transform('foo')).to eq('foo')
        expect(prop.transform(true)).to be true
        expect(prop.transform(false)).to be false
      end
    end
  end

  describe "#view_template" do
    it 'should require subclasses to have view_template method' do
      prop = PhlexStorybook::Props::Base.new(key: 'foo')
      expect { prop.view_template }.to raise_error(NotImplementedError)
    end
  end
end
