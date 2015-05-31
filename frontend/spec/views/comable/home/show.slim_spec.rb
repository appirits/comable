describe 'comable/home/show' do
  let!(:product) { create(:product, :with_stock) }

  before { assign(:products, [product]) }

  it 'renders attributes in products' do
    render
    expect(rendered).to include(product.name)
  end
end
