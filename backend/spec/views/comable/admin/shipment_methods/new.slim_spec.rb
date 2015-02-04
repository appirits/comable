describe 'comable/admin/shipment_methods/new' do
  let(:shipment_method) { FactoryGirl.build(:shipment_method) }

  before { assign(:shipment_method, shipment_method) }

  it 'renders new shipment_method form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_shipment_methods_path, 'post'
  end
end
