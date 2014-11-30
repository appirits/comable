describe Comable::Stock do
  it { expect { described_class.new }.to_not raise_error }

  context 'belongs_to' do
    let(:stock) { FactoryGirl.create(:stock, :with_product) }

    describe 'product' do
      subject { stock.product }
      it { should be }
      its(:name) { should be }
    end
  end

  describe 'Validations' do
    subject { described_class.new }

    describe '#quantity' do
      it 'is valid with greater than 0' do
        subject.quantity = 1
        is_expected.to be_valid
      end

      it 'is valid with equal 0' do
        subject.quantity = 0
        is_expected.to be_valid
      end

      it 'is invalid with less than 0' do
        subject.quantity = -1
        is_expected.to be_invalid
      end
    end
  end
end
