describe 'comable/admin/shipment_methods/new' do
  before(:each) do
    assign(:shipment_method, FactoryGirl.build(:shipment_method))
  end

  it 'renders new shipment_method form' do
    render

    assert_select 'form[action=?][method=?]', comable.admin_shipment_methods_path, 'post' do
    end
  end
end
