describe 'comable/admin/orders/index' do
  let!(:orders) { FactoryGirl.create_list(:order, 2, :completed) }

  let(:q) { Comable::Order.ransack }

  before { assign(:q, q) }
  before { assign(:orders, q.result.page(1)) }

  it 'renders a list of orders' do
    render
    expect(rendered).to include(*orders.map(&:code))
  end
end
