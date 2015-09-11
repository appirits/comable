describe Comable::OrderItem do
  it { expect { described_class.new }.to_not raise_error }

  describe 'validations' do
    subject(:order_item) { build(:order_item) }

    describe 'for quantity' do
      it 'is valid with greater than 0' do
        subject.quantity = 1
        is_expected.to be_valid
      end

      it 'is invalid with equal 0' do
        subject.quantity = 0
        is_expected.to be_invalid
      end

      it 'is invalid with less than 0' do
        subject.quantity = -1
        is_expected.to be_invalid
      end
    end
  end

  describe '#stock=' do
    it 'should sets product with vatiant' do
      subject.variant = build(:variant)
      subject.stock = build(:stock)
      expect(subject.stock).to eq(subject.variant.stock)
    end

    it 'should sets product without vatiant' do
      subject.variant = nil
      subject.stock = build(:stock)
      expect(subject.variant).to be_new_record
    end
  end
end
