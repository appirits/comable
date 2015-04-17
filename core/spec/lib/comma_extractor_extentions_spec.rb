describe Comma::Extractor do
  describe '#hash_to_method_path' do
    subject { described_class.new(self, :default, {}) }

    it 'converts simple hash to array correctly' do
      source = { foo: { bar: :sample } }
      destination = [:foo, :bar, :sample]
      expect(subject.send(:hash_to_method_path, source)).to eq(destination)
    end

    it 'converts complicated hash to array correctly' do
      source = { foo: { bar: [:sample1, :sample2] }, baz: :qux }
      destination = [:foo, :bar, [:sample1, :sample2]]
      expect(subject.send(:hash_to_method_path, source)).to eq(destination)
    end
  end

  describe '#nested_human_attribute_name' do
    let(:target_class) { Comable::OrderItem }

    subject { described_class.new(target_class, :default, {}) }

    it 'converts simple array to human attribute name correctly' do
      source = [:foo, :bar, :sample]
      destination = 'Foo/Bar/Sample'
      expect(subject.send(:nested_human_attribute_name, target_class, source)).to eq(destination)
    end

    # NOTE: This test depends on `OrderItem`, `Order` and `Address` models
    it 'converts complicated array to human attribute name correctly' do
      source = [:order, :bill_address, :family_name]
      destination = [
        Comable::OrderItem.human_attribute_name(:order),
        Comable::Order.human_attribute_name(:bill_address),
        Comable::Address.human_attribute_name(:family_name)
      ].join('/')
      expect(subject.send(:nested_human_attribute_name, target_class, source)).to eq(destination)
    end
  end
end
