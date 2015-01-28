describe 'comable/admin/customers/show' do
  let!(:customer) { FactoryGirl.create(:customer) }

  before { assign(:customer, customer) }

  it 'renders attributes in customer' do
    render
    expect(rendered).to include(customer.email)
  end
end
