describe 'comable/admin/stocks/index' do
  let!(:product) { FactoryGirl.create(:product) }
  let!(:stocks) { FactoryGirl.create_list(:stock, 2, product: product) }

  let(:q) { product.stocks.ransack }

  before { assign(:q, q) }
  before { assign(:product, product) }
  before { assign(:stocks, q.result.page(1)) }

  it 'renders a list of stocks' do
    render
    expect(rendered).to include(*stocks.map(&:code))
  end
end
