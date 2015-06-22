describe Comable::Admin::ThemesController do
  routes { Comable::Core::Engine.routes }

  let(:theme) { build(:theme) }
  let(:path) { 'path/to/file.liquid' }

  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/themes').to route_to('comable/admin/themes#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/themes/new').to route_to('comable/admin/themes#new')
    end

    it 'routes to #show' do
      expect(get: "/admin/themes/#{theme.name}").to route_to('comable/admin/themes#show', id: theme.name)
    end

    it 'routes to #edit' do
      expect(get: "/admin/themes/#{theme.name}/edit").to route_to('comable/admin/themes#edit', id: theme.name)
    end

    it 'routes to #create' do
      expect(post: '/admin/themes').to route_to('comable/admin/themes#create')
    end

    it 'routes to #update' do
      expect(put: "/admin/themes/#{theme.name}").to route_to('comable/admin/themes#update', id: theme.name)
    end

    it 'routes to #tree' do
      expect(get: "/admin/themes/#{theme.name}/tree").to route_to('comable/admin/themes#tree', id: theme.name)
    end

    it 'routes to #show_file' do
      expect(get: "/admin/themes/#{theme.name}/file/#{path}").to route_to('comable/admin/themes#show_file', id: theme.name, path: path)
    end

    it 'routes to #update_file' do
      expect(put: "/admin/themes/#{theme.name}/file/#{path}").to route_to('comable/admin/themes#update_file', id: theme.name, path: path)
    end

    it 'routes to #use' do
      expect(put: "/admin/themes/#{theme.name}/use").to route_to('comable/admin/themes#use', id: theme.name)
    end
  end
end
