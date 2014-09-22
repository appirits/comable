describe 'ComableShipmentMethods' do
  describe 'GET /comable/admin/shipment_methods' do
    it 'works! (now write some real specs)' do
      get comable.admin_shipment_methods_path
      expect(response).to have_http_status(200)
    end
  end
end
