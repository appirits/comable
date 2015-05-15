describe 'comable/products/show.html.slim' do
  let(:product) { build(:product) }
  let(:add_cart_button) { '.add_cart input[type=submit]' }

  before { assign(:product, product) }
  before { render }

  context '商品が登録されている場合' do
    it '商品が表示されること' do
      expect(rendered).to match(product.name)
    end
  end

  context '在庫あり商品の場合' do
    let(:stock) { create(:stock, :stocked) }
    let(:product) { create(:product, stocks: [stock]) }

    it 'カート投入ボタンが存在すること' do
      expect(rendered).to have_selector add_cart_button
    end
  end

  context '在庫なし商品の場合' do
    let(:stock) { create(:stock, :unstocked) }
    let(:product) { create(:product, stocks: [stock]) }

    it 'カート投入ボタンが存在しないこと' do
      expect(rendered).not_to have_selector add_cart_button
    end
  end
end
