describe Comable::OrderItem do
  it { expect { described_class.new }.to_not raise_error }

  describe 'validations' do
    subject(:order_item) { FactoryGirl.build(:order_item) }

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
end
