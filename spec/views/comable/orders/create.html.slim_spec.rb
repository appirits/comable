describe 'comable/orders/create.html.slim' do
  let(:order) { FactoryGirl.create(:order) }

  before { order.complete }
  before { assign(:order, order) }
  before { render }

  it '受注コードが表示されること' do
    expect(rendered).to match(order.code)
  end
end
