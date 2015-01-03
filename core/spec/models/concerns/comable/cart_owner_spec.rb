class DummyCustomer
  include ActiveRecord::Validations
  include Comable::CartOwner
end

describe Comable::CartOwner do
  let(:quantity) { 2 }
  let(:order_details) { FactoryGirl.build_list(:order_detail, 5, quantity: quantity) }

  subject { DummyCustomer.new }

  before { allow(subject).to receive(:cart_items).and_return(order_details) }

  it 'has cart items' do
    expect(subject.cart.count).to eq(order_details.count * quantity)
  end
end
