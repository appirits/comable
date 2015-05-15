describe 'comable/admin/products/index' do
  let!(:products) { create_list(:product, 2) }

  let(:q) { Comable::Product.ransack }

  before { assign(:q, q) }
  before { assign(:products, q.result.page(1)) }

  it 'renders a list of products' do
    render
    expect(rendered).to include(*products.map(&:name))
  end
end
