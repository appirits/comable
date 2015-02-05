describe 'ShipmentMethods' do
  sign_in_admin

  # Patch to the `comable` method.
  # Because `*_path` that passed `script_name` option returns wrong value in Rails 4.2.
  let(:_comable) { comable.routes.url_helpers }

  describe 'GET /comable/admin/shipment_methods' do
    it 'works! (now write some real specs)' do
      get _comable.admin_shipment_methods_path
      expect(response).to have_http_status(200)
    end
  end
end
