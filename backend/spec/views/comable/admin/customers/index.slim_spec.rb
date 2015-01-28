describe 'comable/admin/customers/index' do
  let!(:customers) { FactoryGirl.create_list(:customer, 2) }

  let(:q) { Comable::Customer.ransack }

  before { assign(:q, q) }
  before { assign(:customers, q.result.page(1)) }

  it 'renders a list of customers' do
    render
    expect(rendered).to include(*customers.map(&:email))
  end
end
