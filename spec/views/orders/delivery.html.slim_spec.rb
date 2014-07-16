describe 'comable/orders/delivery.html.slim' do
  before { assign(:order, Comable::Order.new) }
  before { render }

  it '配送先情報入力画面が表示されること' do
    expect(rendered).to match(comable.delivery_order_path)
  end
end
