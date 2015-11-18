describe Comable::Order do
  subject(:order) { build(:order) }

  subject { order }

  it { is_expected.to belong_to(:bill_address).class_name(Comable::Address.name).dependent(:destroy) }
  it { is_expected.to belong_to(:ship_address).class_name(Comable::Address.name).dependent(:destroy) }
  it { is_expected.to have_many(:shipments).class_name(Comable::Shipment.name).dependent(:destroy).inverse_of(:order) }

  describe 'validations' do
    it 'requires the code' do
      allow(subject).to receive(:generate_code).and_return(nil)
      is_expected.to validate_presence_of(:code)
    end

    context "when state is 'orderer'" do
      before { order.state = 'orderer' }

      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_length_of(:email).is_at_most(255) }
    end

    context "when state is 'delivery'" do
      before { order.state = 'delivery' }

      it { is_expected.to validate_presence_of(:bill_address) }
    end

    context "when state is 'shipment'" do
      before { order.state = 'shipment' }

      it { is_expected.to validate_presence_of(:ship_address) }
    end

    context "when state is 'payment'" do
      before { order.state = 'payment' }
      before { allow(order).to receive(:shipment_required?).and_return(true) }

      it { is_expected.to validate_presence_of(:shipments) }
    end

    context "when state is 'confirm'" do
      before { order.state = 'confirm' }
      before { allow(order).to receive(:payment_required?).and_return(true) }

      it { is_expected.to validate_presence_of(:payment) }
    end

    context "when state is 'completed'" do
      before { order.state = 'completed' }

      it { is_expected.to validate_presence_of(:payment_fee) }
      it { is_expected.to validate_presence_of(:shipment_fee) }
      it { is_expected.to validate_presence_of(:total_price) }
    end

    context 'when user is registered' do
      before { subject.attributes = { guest_token: nil, user: create(:user) } }
      before { subject.save }

      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:completed_at) }
    end

    context 'when user is guest' do
      before { subject.attributes = { guest_token: 'abc123', user: nil } }
      before { allow(subject).to receive(:generate_guest_token) }

      it { is_expected.to validate_presence_of(:guest_token) }
      it { is_expected.to validate_uniqueness_of(:guest_token).scoped_to(:completed_at) }
    end

    describe 'with order_items' do
      subject(:order) { create(:order, :with_order_items) }

      let(:order_item) { subject.order_items.first }
      let(:stock) { order_item.variant.stocks.first }

      context 'when out of stock' do
        it 'has errors' do
          # Create shipments
          order.assign_inventory_units_to_shipments

          # Set the quantity to the stock item
          stock.update!(quantity: 0)

          expect { order.complete! }.to raise_error(ActiveRecord::RecordInvalid, /#{stock.name_with_sku}/)
          expect(order.errors['order_items.quantity'].any?).to be
        end
      end
    end
  end

  describe '#complete!' do
    subject { create(:order, :for_confirm, :with_order_items) }

    let(:shipment_method) { build(:shipment_method) }
    let(:order_item) { subject.order_items.first }
    let(:stock) { order_item.variant.stocks.first }

    it 'has completed_at' do
      expect { subject.complete! }.to change { subject.reload.completed_at }.from(nil)
    end

    it 'has code' do
      subject.complete!
      expect(subject.code).to match(/^C\d{11}$/)
    end

    it 'has total_price' do
      quantity = 10
      order_item.update!(quantity: quantity)
      stock.update!(quantity: quantity)

      subject.complete!

      item_total_price = order_item.variant.price * order_item.quantity
      total_price = item_total_price + subject.current_shipment_fee + subject.current_payment_fee

      expect(subject.total_price).to eq(total_price)
    end

    it 'subtracts the quantity of the product' do
      # Set the quantity to the order item and the stock item
      quantity = 10
      order_item.update!(quantity: quantity)
      stock.update!(quantity: quantity)

      # Subtract the quantity
      expect { subject.complete! }.to change { stock.reload.quantity }.from(order_item.quantity).to(0)
    end

    context 'with shipment' do
      subject { create(:order, :for_shipment, :with_order_items) }

      it 'has shipment_fee' do
        subject.complete!
        expect(subject.shipment_fee).to eq(subject.shipment.fee)
      end

      it 'has total_price' do
        subject.complete!
        expect(subject.total_price).to eq(subject.current_item_total_price + subject.shipment.fee)
      end

      it 'has a shipment that has been ready' do
        subject.complete!
        expect(subject.shipment).to be_ready
      end
    end

    context 'with user' do
      let(:address) { create(:address) }

      before { subject.update(bill_address: address, ship_address: address) }

      context 'has addresses used in order' do
        let(:user) { create(:user, addresses: [address]) }

        before { subject.update(user: user) }

        it 'has copied address from order to user' do
          subject.complete!
          expect(user.bill_address).to eq(address)
          expect(user.ship_address).to eq(address)
        end
      end

      context 'has addresses not used in order' do
        let(:user) { create(:user, :with_addresses) }

        before { subject.update(user: user) }

        it 'has cloned address from order to user' do
          subject.complete!
          expect(user.bill_address).not_to eq(address)
          expect(user.ship_address).not_to eq(address)
          expect(user.bill_address.contents).to eq(address.contents)
          expect(user.ship_address.contents).to eq(address.contents)
        end
      end
    end
  end

  describe 'attributes' do
    describe '#save' do
      context 'incomplete order' do
        before { subject.save }
        before { subject.reload }

        its(:completed_at) { should be_nil }

        context 'with user address' do
          subject(:order) { build(:order, user: user) }

          let(:user) { create(:user, :with_addresses) }

          its(:bill_address) { is_expected.to be }
          its(:ship_address) { is_expected.to be }
        end
      end
    end
  end

  describe '#paid?' do
    it 'returns true when it does not have a payment' do
      expect(subject.paid?).to be true
    end

    it 'returns true when it has the completed payment' do
      payment = build(:payment)
      subject.payment = payment

      allow(payment).to receive(:completed?).and_return(true)

      expect(subject.paid?).to be true
    end

    it 'returns false when it has the incompleted payment' do
      payment = build(:payment)
      subject.payment = payment
      expect(subject.paid?).to be false
    end
  end

  describe '#shipped?' do
    it 'returns true when it does not have any shipments' do
      expect(subject.shipped?).to be true
    end

    it 'returns true when it has the completed shipment' do
      shipment = build(:shipment)
      subject.shipments = [shipment]

      allow(shipment).to receive(:completed?).and_return(true)

      expect(subject.shipped?).to be true
    end

    it 'returns false when it has the incompleted shipment' do
      shipment = build(:shipment)
      subject.shipments = [shipment]
      expect(subject.shipped?).to be false
    end
  end

  describe '#can_ship?' do
    it 'returns true when it has the ready shipment' do
      shipment = build(:shipment)
      pending_shipment = build(:shipment)
      order.shipments = [pending_shipment, shipment]

      allow(shipment).to receive(:ready?).and_return(true)
      allow(subject).to receive(:paid?).and_return(true)
      allow(subject).to receive(:completed?).and_return(true)

      expect(subject.can_ship?).to be true
    end

    it 'returns false when it has the pending shipment' do
      pending_shipment = build(:shipment)
      order.shipments = [pending_shipment]

      allow(subject).to receive(:paid?).and_return(true)
      allow(subject).to receive(:completed?).and_return(true)

      expect(subject.can_ship?).to be false
    end

    it 'returns false when it is unpaid' do
      shipment = build(:shipment)
      order.shipments = [shipment]

      allow(shipment).to receive(:ready?).and_return(true)
      allow(subject).to receive(:paid?).and_return(false)
      allow(subject).to receive(:completed?).and_return(true)

      expect(subject.can_ship?).to be false
    end

    it 'returns false when it is completed' do
      shipment = build(:shipment)
      order.shipments = [shipment]

      allow(shipment).to receive(:ready?).and_return(true)
      allow(subject).to receive(:paid?).and_return(true)
      allow(subject).to receive(:completed?).and_return(false)

      expect(subject.can_ship?).to be false
    end
  end
end
