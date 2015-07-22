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
      when 'orders:edit'
        new DynamicOrder
      when 'pages:new', 'pages:show', 'pages:edit', 'pages:update', 'pages:create'
        new Page
      when 'navigations:new', 'navigations:show', 'navigations:edit', 'navigations:update', 'navigations:create'
        new Navigation
