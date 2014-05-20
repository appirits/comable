require 'spec_helper'

describe 'comable/products/index.html.slim' do
  let(:products) { FactoryGirl.create_list(:product, 5, :many) }
  let(:product) { products.first }

  context '商品が登録されている場合' do
    before { assign(:products, products) }
    before { render }

    it '商品が表示されること' do
      expect(rendered).to match(product.name)
    end
  end
end
