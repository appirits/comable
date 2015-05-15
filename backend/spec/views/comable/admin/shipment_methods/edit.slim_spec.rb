describe 'comable/admin/shipment_methods/edit' do
  let(:shipment_method) { create(:shipment_method) }

  before { assign(:shipment_method, shipment_method) }

  it 'renders the edit shipment_method form' do
    render
    assert_select 'form[action=?]', comable.admin_shipment_method_path(shipment_method)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
