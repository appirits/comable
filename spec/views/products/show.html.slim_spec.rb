require 'spec_helper'

describe 'comable/products/show.html.slim' do
  let(:product) { FactoryGirl.build(:product) }
  let(:add_cart_button) { '.add_cart input[type=submit]' }

  before { assign(:product, product) }
  before { render }

  context '商品が登録されている場合' do
    it '商品が表示されること' do
      expect(rendered).to match(product.name)
    end
  end

  context '在庫あり商品の場合' do
    let(:stock) { FactoryGirl.create(:stock, :unsold) }
    let(:product) { FactoryGirl.create(:product, comable_stocks: [stock]) }

    it 'カート投入ボタンが存在すること' do
      expect(rendered).to have_selector add_cart_button
    end
  end

  context '在庫なし商品の場合' do
    let(:stock) { FactoryGirl.create(:stock, :soldout) }
    let(:product) { FactoryGirl.create(:product, comable_stocks: [stock]) }

    it 'カート投入ボタンが存在しないこと' do
      expect(rendered).not_to have_selector add_cart_button
    end
  end
end
