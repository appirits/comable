$(->
  new Dispatcher()
)

class Dispatcher
  constructor: ->
    @init_page_scripts()

  init_page_scripts: ->
    page = $('body').attr('data-page')
    return false unless page

    path = page.split(':')
    contoller_name = path[0]
    action_name = path[1]

    switch page
      when 'orders:edit'
        new DynamicOrder()
