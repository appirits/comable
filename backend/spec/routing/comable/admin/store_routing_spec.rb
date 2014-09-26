describe Comable::Admin::StoreController do
  routes { Comable::Core::Engine.routes }

  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/admin/store/new').to route_to('comable/admin/store#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/store').to route_to('comable/admin/store#show')
    end

    it 'routes to #edit' do
      expect(get: '/admin/store/edit').to route_to('comable/admin/store#edit')
    end

    it 'routes to #create' do
      expect(post: '/admin/store').to route_to('comable/admin/store#create')
    end

    it 'routes to #update' do
      expect(put: '/admin/store').to route_to('comable/admin/store#update')
    end
  end
end
