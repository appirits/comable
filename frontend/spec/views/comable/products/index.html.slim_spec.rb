describe 'comable/products/index.html.slim' do
  let!(:product) { create(:product) }

  context '商品が登録されている場合' do
    before { assign(:products, product.class.page(1)) }
    before { render }

    it '商品が表示されること' do
      expect(rendered).to match(product.name)
    end
  end
end
