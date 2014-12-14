feature 'Checkout' do
  given!(:product) { FactoryGirl.create(:product, :with_stock) }

  given(:order) { FactoryGirl.build(:order, bill_address: address, ship_address: address, order_details: [order_detail]) }
  given(:order_detail) { FactoryGirl.build(:order_detail, stock: stock) }
  given(:address) { FactoryGirl.build(:address) }
  given(:stock) { product.stocks.first }
  given(:current_customer) { FactoryGirl.build(:customer) }

  background do
    allow(Comable::Customer).to receive(:new).and_return(current_customer)
    allow(current_customer).to receive(:incomplete_order).and_return(order)
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
