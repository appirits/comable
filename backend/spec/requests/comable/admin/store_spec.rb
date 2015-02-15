describe 'Store' do
  sign_in_admin

  # Patch to the `comable` method.
  # Because `*_path` that passed `script_name` option returns wrong value in Rails 4.2.
  #
  #   # `comable.admin_store_path` is expanded as blow.
  #   # refs: actionpack-4.2.0/lib/action_dispatch/routing/routes_proxy.rb:32
  #   comable.routes.url_helpers.admin_store_path(..., script_name: "")
  #
  #   # Rails 4.2
  #   #=> "/admin/store"
  #
  #   # Rails 4.1
  #   #=> "/comable/admin/store"
  #
  let(:_comable) { comable.routes.url_helpers }

  describe 'GET /comable/admin/store' do
    it 'display the store' do
      get _comable.admin_store_path
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH /comable/admin/store' do
    it 'create a store and redirect to the page' do
      put _comable.admin_store_path, store: { name: 'test' }
      expect(response).to redirect_to(_comable.admin_store_path)
    end
  end
end
