#= require jquery
#= require jasmine-jquery
#= require comable/admin/user_selector

describe 'UserSelector', ->
  described_class = null
  subject = null

  beforeEach ->
    described_class = UserSelector
    subject = described_class.prototype

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
