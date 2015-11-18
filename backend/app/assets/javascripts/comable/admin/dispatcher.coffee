$(->
  new Dispatcher
)

class Dispatcher
  constructor: ->
    @initialize_page_scripts()

  initialize_page_scripts: ->
    page = $('body').attr('data-page')
    return false unless page

    path = page.split(':')
    contoller_name = path[0]
    action_name = path[1]

    switch page
      when 'draft_orders:new', 'draft_orders:create', 'draft_orders:edit', 'draft_orders:update'
        new OrderItemBuilder
        new UserSelector
        new DynamicOrder
      when 'orders:new', 'orders:create', 'orders:edit', 'orders:update'
        new DynamicOrder
      when 'pages:new', 'pages:show', 'pages:edit', 'pages:update', 'pages:create'
        new Page
      when 'products:new', 'products:show', 'products:edit', 'products:update', 'products:create'
        new Product
        new Variant
        new Stock
      when 'variants:show', 'variants:edit', 'variants:update'
        new Stock
      when 'navigations:new', 'navigations:show', 'navigations:edit', 'navigations:update', 'navigations:create'
        new Navigation
      when 'themes:tree'
        new ThemeTree
      when 'themes:show_file'
        new ThemeTree
        new ThemeEditor
