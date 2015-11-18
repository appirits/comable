describe Comable::DraftOrder do
  subject { described_class.new }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:bill_address) }
  it { is_expected.to validate_presence_of(:ship_address) }

  it 'requires a payment when a payment method is existed' do
    create(:payment_method)
    is_expected.to validate_presence_of(:payment)
  end

  it 'requires a shipment when a shipment method is existed' do
    create(:shipment_method)
    is_expected.to validate_presence_of(:shipments)
  end

  it 'is draft' do
    expect(subject).to be_draft
  end

  it 'has :draft state' do
    expect(subject.state).to eq('draft')
  end

  describe '#next_draft_state' do
    let(:valid_attributes) do
      attributes_for(:order).merge(
        bill_address_attributes: attributes_for(:address),
        ship_address_attributes: attributes_for(:address),
        order_items_attributes: [attributes_for(:order_item)]
      )
    end

    it 'has :completed state' do
      subject.attributes = valid_attributes

      subject.next_draft_state

      expect(subject.state).to eq('completed')
    end

    it 'has :shipment state when a shipment method is existed' do
      create(:shipment_method)
      subject.attributes = valid_attributes

      subject.next_draft_state

      expect(subject.state).to eq('shipment')
    end

    it 'has :completed state via :shipment state when a shipment method is existed' do
      shipment_method = create(:shipment_method)
      subject.attributes = valid_attributes

      subject.next_draft_state

      subject.attributes = { shipments_attributes: [subject.shipments.first.attributes.merge(shipment_method_id: shipment_method.id)] }
      subject.next_draft_state

      expect(subject.state).to eq('completed')
    end

    it 'corrects the shipment fee when a shipment method is existed' do
      shipment_method = create(:shipment_method)
      subject.attributes = valid_attributes

      subject.next_draft_state

      subject.attributes = { shipments_attributes: [subject.shipments.first.attributes.merge(shipment_method_id: shipment_method.id)] }
      subject.next_draft_state

      expect(subject.shipment_fee).to eq(shipment_method.fee)
    end

    it 'raises an error when the payment dose not have a payment method' do
      subject.attributes = valid_attributes
      subject.build_payment

      expect { subject.next_draft_state }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
