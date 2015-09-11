class DummyUser
  include ActiveModel::Validations
  include Comable::CartOwner
end

describe Comable::CartOwner do
  let(:quantity) { 2 }
  let(:order_items) { build_list(:order_item, 5, quantity: quantity) }

  subject { DummyUser.new }

  before { allow(subject).to receive(:cart_items).and_return(order_items) }

  it 'has cart items' do
    expect(subject.cart.count).to eq(order_items.count * quantity)
  end

  context 'with errors' do
    let(:stock) { create(:stock, :unstocked, :with_product) }
    let(:cart_item) { subject.cart_items.first }

    before { allow(cart_item).to receive(:stock).and_return(stock) }
    before { cart_item.valid? }

    it 'has cart with errors' do
      expect(subject.cart.errors.full_messages.first).to include(stock.name)
    end
  end
end
