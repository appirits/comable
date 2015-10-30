describe Comable::Stock do
  it { is_expected.to belong_to(:variant).class_name(Comable::Variant.name) }
  it { is_expected.to belong_to(:stock_location).class_name(Comable::StockLocation.name) }

  it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }

  it { is_expected.to scope(:by_newest) { reorder(created_at: :desc) } }

  describe '#product=' do
    it 'should sets product with vatiant' do
      subject.variant = build(:variant)
      subject.product = build(:product)
      expect(subject.product).to eq(subject.variant.product)
    end

    it 'should sets product without vatiant' do
      subject.variant = nil
      subject.product = build(:product)
      expect(subject.variant).to be_new_record
    end
  end

  describe '#sku_v?' do
    it 'should returns false when it has only option of variant' do
      subject.variant = build(:variant, options: [name: 'Size', value: 'M'])
      subject.product = build(:product)
      expect(subject.sku_v?).to be false
    end

    it 'should returns true when it has two options of variant' do
      subject.variant = build(:variant, options: [name: 'Size', value: 'M'] + [name: 'Color', value: 'Red'])
      subject.product = build(:product)
      expect(subject.sku_v?).to be false
    end
  end

  describe '#unstocked?' do
    it 'returns ture when it is out of stock' do
      quantity = 10
      subject.quantity = quantity - 1
      expect(subject.unstocked?(quantity: quantity)).to be true
    end

    it 'returns false when it is in stock' do
      quantity = 10
      subject.quantity = quantity
      expect(subject.unstocked?(quantity: quantity)).to be false
    end
  end
end
