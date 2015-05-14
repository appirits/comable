describe Comable::ApplicationHelper do
  subject { helper }

  describe '#liquidize' do
    it 'returns liquidized string' do
      string = 'John'
      expect(subject.liquidize('Name: {{ name }}', name: string)).to include(string)
    end

    it 'allows the specified method of a model to liquidize' do
      order = FactoryGirl.build(:order, total_price: 100)
      expect(subject.liquidize('Total price: {{ order.total_price }}', order: order)).to include(order.total_price.to_s)
    end

    it 'denies the specified method of a model to liquidize' do
      order = FactoryGirl.build(:order, email: 'john@example.com')
      expect(subject.liquidize('email: {{ order.email }}', order: order)).not_to include(order.email)
    end
  end
end
