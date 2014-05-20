require 'spec_helper'

describe 'comable/orders/orderer.html.slim' do
  before { assign(:order, Comable::Order.new) }
  before { render }

  it '注文者情報入力画面が表示されること' do
    expect(rendered).to match(comable.orderer_order_path)
  end
end
