describe 'comable/orders/orderer.html.slim' do
  helper Comable::ApplicationHelper

  let(:bill_address_attributes) { attributes_for(:address) }
  let(:order) { build(:order, :for_delivery, bill_address_attributes: bill_address_attributes) }

  before { allow(view).to receive(:current_order).and_return(order) }
  before { assign(:order, order) }

  it 'render the page to input billing address' do
    expect { render }.to change { rendered }.to include(*bill_address_attributes.values)
  end
end
