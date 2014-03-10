require 'spec_helper'

describe "comable/products/show.html.slim" do
  let (:product) { FactoryGirl.build(:product) }

  context "商品が登録されている場合" do
    before { assign(:product, product) }
    before { render }

    it "商品が表示されること" do
      expect(rendered).to match(product.name)
    end
  end
end
