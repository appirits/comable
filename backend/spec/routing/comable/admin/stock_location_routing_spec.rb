describe Comable::Admin::StockLocationsController do
  routes { Comable::Core::Engine.routes }

  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/stock_locations').to route_to('comable/admin/stock_locations#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/stock_locations/new').to route_to('comable/admin/stock_locations#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/stock_locations/1').to route_to('comable/admin/stock_locations#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/stock_locations/1/edit').to route_to('comable/admin/stock_locations#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/stock_locations').to route_to('comable/admin/stock_locations#create')
    end

    it 'routes to #update' do
      expect(put: '/admin/stock_locations/1').to route_to('comable/admin/stock_locations#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/stock_locations/1').to route_to('comable/admin/stock_locations#destroy', id: '1')
    end
  end
end
