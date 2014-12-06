describe 'comable/orders/delivery.html.slim' do
  let(:path_to_shipment) { comable.next_order_path(state: :shipment) }

  before { assign(:order, Comable::Order.new) }
  before { allow(view).to receive(:next_order_path).and_return(path_to_shipment)  }
  before { render }

  it '配送先情報入力画面が表示されること' do
    expect(rendered).to match(comable.delivery_order_path)
  end
end
