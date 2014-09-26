describe 'Store' do
  describe 'GET /comable/admin/store' do
    it 'Redirect to create a store' do
      get comable.admin_store_path
      expect(response).to have_http_status(302)
    end
  end
end
