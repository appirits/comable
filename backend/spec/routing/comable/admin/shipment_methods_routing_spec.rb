describe Comable::Admin::ShipmentMethodsController do
  routes { Comable::Core::Engine.routes }

  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/shipment_methods').to route_to('comable/admin/shipment_methods#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/shipment_methods/new').to route_to('comable/admin/shipment_methods#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/shipment_methods/1').to route_to('comable/admin/shipment_methods#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/shipment_methods/1/edit').to route_to('comable/admin/shipment_methods#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: "/admin/shipment_methods").to route_to('comable/admin/shipment_methods#create')
    end

    it 'routes to #update' do
      expect(put: '/admin/shipment_methods/1').to route_to('comable/admin/shipment_methods#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/shipment_methods/1').to route_to('comable/admin/shipment_methods#destroy', id: '1')
    end
  end
end
