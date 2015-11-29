describe Comable::Category do
  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:products).class_name(Comable::Product.name) }
  end

  describe '#touch_all_products' do
    it 'touches products after saving self' do
      category = create(:category)
      product = create(:product, categories: [category])
      expect { category.update!(name: "NEW: #{category.name}") }.to change { product.reload.updated_at }
    end
  end
end
