describe 'comable/orders/delivery.html.slim' do
  helper Comable::ApplicationHelper

  let(:ship_address_attributes) { FactoryGirl.attributes_for(:address) }
  let(:order) { FactoryGirl.build(:order, :for_delivery, ship_address_attributes: ship_address_attributes) }

  before { allow(view).to receive(:current_order).and_return(order) }
  before { assign(:order, order) }

  it 'render the page to input shipping address' do
    expect { render }.to change { rendered }.to include(*ship_address_attributes.values)
  end
end
