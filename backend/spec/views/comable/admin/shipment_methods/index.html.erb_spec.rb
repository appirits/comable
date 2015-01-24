describe 'comable/admin/shipment_methods/index' do
  let!(:shipment_methods) { FactoryGirl.create_list(:shipment_method, 2) }

  before { assign(:shipment_methods, Comable::ShipmentMethod.page(1)) }

  it 'renders a list of shipment_methods' do
    render
  end
end
