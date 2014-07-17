require 'rspec/example_steps'

feature 'カート処理' do
  background { product }

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
        click_button 'カートに入れる'
        expect(page).to have_content I18n.t('comable.carts.add_product')
      end

      When '注文画面に遷移して' do
        visit comable.cart_path
        click_link '注文'
        expect(page).to have_content '規約に同意して注文'
      end

      When '注文者情報入力画面に遷移して' do
        visit comable.new_order_path
        click_link '規約に同意して注文'
        expect(page).to have_content '注文者情報入力'
      end

      When '配送先情報入力画面に遷移して' do
        visit comable.orderer_order_path
        within('form') do
          fill_in :order_family_name, with: 'foo'
          fill_in :order_first_name, with: 'bar'
        end
        click_button I18n.t('helpers.submit.create')
        expect(page).to have_content '配送先情報入力'
      end

      When '注文情報確認画面に遷移して' do
        visit comable.delivery_order_path
        click_button I18n.t('helpers.submit.create')
        expect(page).to have_content '注文情報確認'
      end

      Then '注文できること' do
        visit comable.confirm_order_path
        click_button I18n.t('helpers.submit.create')
        expect(page).to have_content '注文完了'
      end
    end
  end

  context '通常商品' do
    given(:product) { FactoryGirl.create(:product, :with_stock) }
    subject { product }
    it_behaves_like '商品が購入できること'
  end

  context 'SKU商品' do
    given(:product) { FactoryGirl.create(:product, :sku) }
    subject { product }
    it_behaves_like '商品が購入できること'
  end
end
