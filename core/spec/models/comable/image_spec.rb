describe Comable::Image do
  describe 'associations' do
    it { is_expected.to belong_to(:product).class_name(Comable::Product.name) }
  end
end
