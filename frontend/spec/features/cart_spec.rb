require 'rspec/example_steps'

feature 'カート処理' do
  given!(:payment_method) { FactoryGirl.create(:payment_method) }
  given!(:shipment_method) { FactoryGirl.create(:shipment_method) }
  given(:order) { FactoryGirl.build(:order) }
  given(:address) { FactoryGirl.build(:address) }
  given(:stock) { product.stocks.first }

  shared_examples '商品が購入できること' do
    # refs:
    #   http://railsware.com/blog/2012/01/08/capybara-with-givenwhenthen-steps-in-acceptance-testing/
    #   http://d.hatena.ne.jp/bowbow99/20090523/1243043153
    Steps 'ゲスト購入' do
      Given '商品が存在するとき' do
        visit comable.products_path
        click_link subject.name
        expect(page).to have_content subject.price
      end

      When '商品をカートに投入して' do
        visit comable.product_path(subject)
        choose subject.stocks.first.code if subject.sku?
        click_button Comable.t('add_to_cart')
        expect(page).to have_content Comable.t('carts.added')
      end

      When '注文画面に遷移して' do
        visit comable.cart_path
        click_button Comable.t('checkout')
        expect(page).to have_button Comable.t('guest_order')
      end

      When '注文者情報入力画面に遷移して' do
        visit comable.signin_order_path
        within('form#edit_order') do
          fill_in :order_email, with: order.email
        end
        click_button Comable.t('guest_order')
        expect(page).to have_content order.class.human_state_name(:orderer)
      end

      When '配送先情報入力画面に遷移して' do
        visit comable.next_order_path(state: :orderer)
        within('form') do
          fill_in :order_email, with: order.email
          fill_in :order_bill_address_attributes_family_name, with: address.family_name
          fill_in :order_bill_address_attributes_first_name, with: address.first_name
          fill_in :order_bill_address_attributes_state_name, with: address.state_name
          fill_in :order_bill_address_attributes_zip_code, with: address.zip_code
          fill_in :order_bill_address_attributes_city, with: address.city
          fill_in :order_bill_address_attributes_phone_number, with: address.phone_number
        end
        click_button Comable.t('next_step')
        expect(page).to have_content order.class.human_state_name(:delivery)
      end

      When '発送方法選択画面に遷移して' do
        visit comable.next_order_path(state: :delivery)
        within('form') do
          fill_in :order_ship_address_attributes_family_name, with: address.family_name
          fill_in :order_ship_address_attributes_first_name, with: address.first_name
          fill_in :order_ship_address_attributes_state_name, with: address.state_name
          fill_in :order_ship_address_attributes_zip_code, with: address.zip_code
          fill_in :order_ship_address_attributes_city, with: address.city
          fill_in :order_ship_address_attributes_phone_number, with: address.phone_number
        end
        click_button Comable.t('next_step')
        expect(page).to have_content order.class.human_state_name(:shipment)
      end

      When '決済方法選択画面に遷移して' do
        visit comable.next_order_path(state: :shipment)
        click_button Comable.t('next_step')
        expect(page).to have_content order.class.human_state_name(:payment)
      end

      When '注文情報確認画面に遷移して' do
        visit comable.next_order_path(state: :payment)
        click_button Comable.t('next_step')
        expect(page).to have_content order.class.human_state_name(:confirm)
      end

      Then '注文できること' do
        visit comable.next_order_path(state: :confirm)
        click_button Comable.t('complete_order')
        expect(page).to have_content order.class.human_state_name(:completed)
      end
    end
  end

  shared_examples '商品を数量指定でカート投入できること' do
    let(:quantity) { stock.quantity.to_s }

    Steps 'ゲスト購入' do
      Given '商品が存在するとき' do
        visit comable.products_path
        click_link subject.name
        expect(page).to have_content subject.price
      end

      When '商品をカートに投入して' do
        visit comable.product_path(subject)
        choose subject.stocks.first.code if subject.sku?
        select quantity, from: 'quantity'
        click_button Comable.t('add_to_cart')
        expect(page).to have_content Comable.t('carts.added')
      end

      Then 'カートが更新されること' do
        visit comable.cart_path
        expect(page).to have_select('quantity', selected: quantity)
      end
    end
  end

  shared_examples '商品の数量変更ができること' do
    let(:quantity) { stock.quantity.to_s }

    Steps 'ゲスト購入' do
      Given '商品が存在するとき' do
        visit comable.products_path
        click_link subject.name
        expect(page).to have_content subject.price
      end

      When '商品をカートに投入して' do
        visit comable.product_path(subject)
        choose subject.stocks.first.code if subject.sku?
        click_button Comable.t('add_to_cart')
        expect(page).to have_content Comable.t('carts.added')
      end

      When '数量を変更して' do
        visit comable.cart_path
        select quantity, from: 'quantity'
        click_button Comable.t('actions.update')
        expect(page).to have_content Comable.t('carts.updated')
      end

      Then 'カートが更新されること' do
        visit comable.cart_path
        expect(page).to have_select('quantity', selected: quantity)
      end
    end
  end

  context '通常商品' do
    subject!(:product) { FactoryGirl.create(:product, :with_stock) }
    it_behaves_like '商品が購入できること'
    it_behaves_like '商品を数量指定でカート投入できること'
    it_behaves_like '商品の数量変更ができること'
  end

  context 'SKU商品' do
    subject!(:product) { FactoryGirl.create(:product, :sku) }
    it_behaves_like '商品が購入できること'
    it_behaves_like '商品を数量指定でカート投入できること'
    it_behaves_like '商品の数量変更ができること'
  end
end
