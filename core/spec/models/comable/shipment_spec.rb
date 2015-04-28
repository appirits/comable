RSpec.describe Comable::Shipment do
  subject { FactoryGirl.create(:shipment) }

  it { is_expected.to belong_to(:order).class_name(Comable::Order.name).inverse_of(:shipment) }
  it { is_expected.to belong_to(:shipment_method).class_name(Comable::ShipmentMethod.name) }

  it { is_expected.to validate_presence_of(:order) }
  it { is_expected.to validate_presence_of(:shipment_method) }
  it { is_expected.to validate_presence_of(:fee) }
  it { is_expected.to validate_length_of(:tracking_number).is_at_most(255) }
  it { is_expected.to validate_numericality_of(:fee).is_greater_than_or_equal_to(0) }

  describe '#copy_attributes_from_shipment_method' do
    context 'when the order is paid' do
      before { allow(subject).to receive(:payment_completed?).and_return(true) }

      it 'not copy the fee' do
        original_fee = subject.fee
        subject.shipment_method.update_attributes(fee: original_fee * 2)
        subject.save!
        expect(subject.fee).not_to eq(subject.shipment_method.fee)
      end
    end

    context 'when the order is not paid' do
      before { allow(subject).to receive(:payment_completed?).and_return(false) }

      it 'copy the fee' do
        original_fee = subject.fee
        subject.shipment_method.update_attributes(fee: original_fee * 2)
        subject.save!
        expect(subject.fee).to eq(subject.shipment_method.fee)
      end
    end
  end
end
