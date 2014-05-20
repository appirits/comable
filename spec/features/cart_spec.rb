require 'spec_helper'

describe "カート処理", type: :feature do
  let (:product) { FactoryGirl.create(:product, stocks: [stock]) }
  let (:stock) { FactoryGirl.create(:stock, :unsold) }

  before { product }

  it "商品詳細画面に遷移できること" do
    visit comable.products_path
    click_link product.name
    expect(page).to have_content product.price
  end

  steps "ゲスト購入の場合" do
    # 商品/在庫レコードの残骸が残ってしまうのでテストケース終了後に削除
    after (:all) { Product.delete_all and Stock.delete_all }

    it "1. 商品をカートに投入できること" do
      visit comable.product_path(product)
      click_button 'カートに入れる'
      expect(page).to have_content I18n.t('comable.carts.add_product')
    end

    it "2. 注文画面に遷移できること" do
      visit comable.cart_path
      click_link '注文'
      expect(page).to have_content "規約に同意して注文"
    end

    it "3. 注文者情報入力画面に遷移できること" do
      visit comable.new_order_path
      click_link "規約に同意して注文"
      expect(page).to have_content "注文者情報入力"
    end

    it "4. 配送先情報入力画面に遷移できること" do
      visit comable.orderer_order_path
      within("form") do
        fill_in :order_family_name, with: 'foo'
        fill_in :order_first_name, with: 'bar'
      end
      click_button I18n.t('helpers.submit.create')
      expect(page).to have_content "配送先情報入力"
    end

    it "5. 注文情報確認画面に遷移できること" do
      visit comable.delivery_order_path
      click_button I18n.t('helpers.submit.create')
      expect(page).to have_content "注文情報確認"
    end

    it "6. 注文できること" do
      visit comable.confirm_order_path
      click_button I18n.t('helpers.submit.create')
      expect(page).to have_content "注文完了"
    end
  end
end
