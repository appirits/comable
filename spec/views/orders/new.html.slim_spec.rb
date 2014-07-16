describe 'comable/orders/new.html.slim' do
  before { render }

  it '購入手続きへのリンクが表示されること' do
    expect(rendered).to match(comable.orderer_order_path)
  end
end
