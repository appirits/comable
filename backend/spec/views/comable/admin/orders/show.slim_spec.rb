describe 'comable/admin/orders/show' do
  let!(:order) { FactoryGirl.create(:order, :completed) }

  before { assign(:order, order) }

  it 'renders attributes in order' do
    render
    expect(rendered).to include(order.code)
  end
end
