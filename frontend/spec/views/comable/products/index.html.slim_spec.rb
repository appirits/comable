describe 'comable/products/index.html.slim' do
  let(:products) { create_list(:product, 5) }
  let(:product) { products.first }

  context '商品が登録されている場合' do
    before { assign(:products, Kaminari.paginate_array(products).page(1)) }
    before { render }

    it '商品が表示されること' do
      expect(rendered).to match(product.name)
    end
  end
end
