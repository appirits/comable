#= require jquery
#= require jasmine-jquery
#= require comable/admin/user_selector

describe 'UserSelector', ->
  described_class = null
  subject = null

  beforeEach ->
    described_class = UserSelector
    subject = described_class.prototype

  describe '#constructor', ->
    beforeEach ->
      spyOn(subject, 'setSelectors')
      # Set @$userSelector
      subject.$userSelector = $('<select />')

    it 'calls #setSelectors', ->
      subject.constructor()
      expect(subject.setSelectors).toHaveBeenCalled()
      expect(subject.setSelectors.calls.count()).toEqual(1)

    it 'handles "select2:select" on @$userSelector with #fillUser', ->
      spyOn(subject, 'fillUser')

      subject.constructor()

      # Trigger "select2:select" event on @$userSelector
      event = $.Event("select2:select")
      event.params =  { data: {} }
      subject.$userSelector.trigger(event)

      expect(subject.fillUser).toHaveBeenCalled()
      expect(subject.fillUser.calls.count()).toEqual(1)

  describe '#setSelectors', ->
    it 'sets @$userSelector', ->
      id = 'js-user-selector'
      setFixtures("<select id=\"#{id}\" />")
      subject.setSelectors()
      expect(subject.$userSelector).toEqual("##{id}")

    it 'sets @$user', ->
      id = 'js-user-fields'
      setFixtures("<div id=\"#{id}\" />")
      subject.setSelectors()
      expect(subject.$user).toEqual("##{id}")

  describe '#fillUser', ->
    user = {
      email: 'example@example.com'
      bill_address: {
        family_name: 'foo'
        first_name: 'bar'
        zip_code: '123-4567'
        state_name: 'Tokyo'
      }
    }

    it 'fills email filed', ->
      setFixtures('<div id="js-user-selector"><input type="text" data-name="email" /></div>')
      subject.$user = $('#js-user-selector')
      subject.fillUser(user)
      expect(subject.$user.find('input')).toHaveValue(user.email)

    it 'fills bill-family-name filed', ->
      setFixtures('<div id="js-user-selector"><input type="text" data-name="bill-family-name" /></div>')
      subject.$user = $('#js-user-selector')
      subject.fillUser(user)
      expect(subject.$user.find('input')).toHaveValue(user.bill_address.family_name)

    it 'fills bill-first-name filed', ->
      setFixtures('<div id="js-user-selector"><input type="text" data-name="bill-first-name" /></div>')
      subject.$user = $('#js-user-selector')
      subject.fillUser(user)
      expect(subject.$user.find('input')).toHaveValue(user.bill_address.first_name)

    it 'fills bill-zip-code filed', ->
      setFixtures('<div id="js-user-selector"><input type="text" data-name="bill-zip-code" /></div>')
      subject.$user = $('#js-user-selector')
      subject.fillUser(user)
      expect(subject.$user.find('input')).toHaveValue(user.bill_address.zip_code)

    it 'fills bill-state-name filed', ->
      setFixtures('<div id="js-user-selector"><input type="text" data-name="bill-state-name" /></div>')
      subject.$user = $('#js-user-selector')
      subject.fillUser(user)
      expect(subject.$user.find('input')).toHaveValue(user.bill_address.state_name)
