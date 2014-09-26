describe Comable::Admin::StoresController do
  routes { Comable::Core::Engine.routes }

  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/stores').to route_to('comable/admin/stores#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/stores/new').to route_to('comable/admin/stores#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/stores/1').to route_to('comable/admin/stores#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/stores/1/edit').to route_to('comable/admin/stores#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/stores').to route_to('comable/admin/stores#create')
    end

    it 'routes to #update' do
      expect(put: '/admin/stores/1').to route_to('comable/admin/stores#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/stores/1').to route_to('comable/admin/stores#destroy', id: '1')
    end
  end
end
