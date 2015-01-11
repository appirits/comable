describe Comable::Category do
  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:products).class_name(Comable::Product.name) }
  end
end
