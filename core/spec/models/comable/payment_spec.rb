RSpec.describe Comable::Payment do
  subject { FactoryGirl.create(:payment) }

  # Disable the automatic change of attributes.
  before { allow(subject).to receive(:order_completed?).and_return(true) }

  it { is_expected.to belong_to(:order).class_name(Comable::Order.name).inverse_of(:payment) }
  it { is_expected.to belong_to(:payment_method).class_name(Comable::PaymentMethod.name) }

  it { is_expected.to validate_presence_of(:order) }
  it { is_expected.to validate_presence_of(:payment_method) }
  it { is_expected.to validate_presence_of(:fee) }
  it { is_expected.to validate_numericality_of(:fee).is_greater_than_or_equal_to(0) }

  describe '#copy_attributes_from_payment_method' do
    context 'when the order is paid' do
      before { allow(subject).to receive(:order_completed?).and_return(true) }

      it 'not copy the fee' do
        original_fee = subject.fee
        subject.payment_method.update_attributes(fee: original_fee * 2)
        subject.save!
        expect(subject.fee).not_to eq(subject.payment_method.fee)
      end
    end

    context 'when the order is not paid' do
      before { allow(subject).to receive(:order_completed?).and_return(false) }

      it 'copy the fee' do
        original_fee = subject.fee
        subject.payment_method.update_attributes(fee: original_fee * 2)
        subject.save!
        expect(subject.fee).to eq(subject.payment_method.fee)
      end
    end
  end

  describe '#next_state!' do
    it 'should change the state form `pending` to `complete`' do
      expect { subject.next_state! }.to change(subject, :state).from('pending').to('complete')
    end
  end
end
