class @UserSelector
  constructor: ->
    @setSelectors()
    @$userSelector.on('select2:select', (event) => @fillUser(event.params.data))

  setSelectors: ->
    @$userSelector = $('#js-user-selector')
    @$user = $('#js-user-fields')

  fillUser: (user) ->
    @$user.find('[data-name="email"]').val(user.email)
    @$user.find('[data-name="bill-family-name"]').val(user.bill_address.family_name)
    @$user.find('[data-name="bill-first-name"]').val(user.bill_address.first_name)
    @$user.find('[data-name="bill-zip-code"]').val(user.bill_address.zip_code)
    @$user.find('[data-name="bill-state-name"]').val(user.bill_address.state_name)
