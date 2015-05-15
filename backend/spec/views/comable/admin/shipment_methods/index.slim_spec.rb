describe 'comable/admin/shipment_methods/index' do
  let!(:shipment_methods) { create_list(:shipment_method, 2) }

  before { assign(:shipment_methods, Comable::ShipmentMethod.page(1)) }

  it 'renders a list of shipment_methods' do
    render
    expect(rendered).to include(*shipment_methods.map(&:name))
  end
end
