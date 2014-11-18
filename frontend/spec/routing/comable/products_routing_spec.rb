describe 'Routes for products' do
  routes { Comable::Core::Engine.routes }

  it 'routes to get #index' do
    expect(get('/products')).to route_to(
      controller: 'comable/products',
      action: 'index'
    )
  end

  it 'routes to get #show' do
    expect(get('/products/1')).to route_to(
      controller: 'comable/products',
      action: 'show',
      id: '1'
    )
  end
end
