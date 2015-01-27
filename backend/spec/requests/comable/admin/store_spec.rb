describe 'Store' do
  describe 'GET /comable/admin/store' do
    it 'display the store' do
      get comable.admin_store_path
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH /comable/admin/store' do
    it 'create a store and redirect to the page' do
      put comable.admin_store_path, store: { name: 'test' }
      expect(response).to redirect_to(comable.admin_store_path)
    end
  end
end
