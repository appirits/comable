feature 'Checkout' do
  given!(:persisted_customer) { FactoryGirl.create(:customer, :with_addresses, password: 'raw-passowrd') }
  given!(:order) { FactoryGirl.create(:order, :for_confirm, order_details: [order_detail]) }

  given(:order_detail) { FactoryGirl.build(:order_detail) }
  given(:current_customer) { FactoryGirl.build(:customer) }

  background do
    allow(Comable::Customer).to receive(:new).and_return(current_customer)
    allow(current_customer).to receive(:incomplete_order).and_return(order)
    allow_any_instance_of(Comable::Customer).to receive(:current_guest_token).and_return(order.guest_token)
  end

  context "when order state was 'cart'" do
    background { order.update_attributes(state: 'cart', email: nil) }

    scenario 'Sign in while checkout flow' do
      visit comable.cart_path

      click_button '注文'

      expect(current_url).to eq(comable.signin_order_url)

      within('form#new_customer') do
        fill_in :customer_email, with: persisted_customer.email
        fill_in :customer_password, with: persisted_customer.password
      end
      click_button 'Log in'

      expect(current_url).to eq(comable.next_order_url(state: :confirm))
    end
  end

  context "when order state was 'confirm'" do
    background { order.update_attributes(state: 'confirm') }

    scenario 'Update the billing address' do
      visit comable.next_order_path(state: :orderer)

      within('form') do
        fill_in :order_email, with: "updated.#{order.email}"
      end

      # TODO: ボタン名につかう翻訳パスを変更または作成
      click_button I18n.t('helpers.submit.update')

      expect(current_url).to eq(comable.next_order_url(state: :confirm))
      expect(order.state).to eq('confirm')
    end
  end
end
