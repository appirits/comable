class DummyOrder
  include ActiveRecord::Validations
  include Comable::Checkout

  attr_accessor :state
  attr_accessor :bill_address
  attr_accessor :ship_address
  attr_accessor :shipment
  attr_accessor :payment_method

  def initialize(_ = {})
  end

  def complete!
  end
end

describe Comable::Checkout do
  subject { DummyOrder.new }

  it 'has state' do
    expect(subject.respond_to?(:state)).to be
  end

  shared_examples "next state is 'shipment' if shipment method is present" do
    let!(:shipment_method) { FactoryGirl.create(:shipment_method) }

    it "state change to 'shipment'" do
      expect { subject.next_state }.to change { subject.state }.to eq('shipment')
    end
  end

  shared_examples "next state is 'payment' if payment method is present" do
    let!(:payment_method) { FactoryGirl.create(:payment_method) }

    it "state change to 'payment'" do
      expect { subject.next_state }.to change { subject.state }.to eq('payment')
    end
  end

  describe '#next_state' do
    context "when state is 'cart'" do
      before { subject.state = 'cart' }

      it "state change to 'orderer'" do
        expect { subject.next_state }.to change { subject.state }.to eq('orderer')
      end

      context 'when billing address is present' do
        let(:bill_address) { FactoryGirl.create(:address) }

        before { subject.bill_address = bill_address }

        it "state change to 'delivery'" do
          expect { subject.next_state }.to change { subject.state }.to eq('delivery')
        end
      end
    end

    context "when state is 'orderer'" do
      before { subject.state = 'orderer' }

      it "state change to 'delivery'" do
        expect { subject.next_state }.to change { subject.state }.to eq('delivery')
      end

      context 'when shipping address is present' do
        let(:ship_address) { FactoryGirl.create(:address) }

        before { subject.ship_address = ship_address }

        it "state change to 'confirm'" do
          expect { subject.next_state }.to change { subject.state }.to eq('confirm')
        end
      end
    end

    context "when state is 'delivery'" do
      before { subject.state = 'delivery' }

      it "state change to 'confirm'" do
        expect { subject.next_state }.to change { subject.state }.to eq('confirm')
      end

      it_behaves_like "next state is 'shipment' if shipment method is present"
      it_behaves_like "next state is 'payment' if payment method is present"
    end

    context "when state is 'shipment'" do
      before { subject.state = 'shipment' }

      before do
        allow(subject).to receive(:build_pending_shipment)

        # Override `arity` method for the stubbed `build_pending_shipment` method.
        # refs: https://github.com/rspec/rspec-expectations/issues/583
        method = double('Method')
        allow(subject).to receive(:method).and_call_original
        allow(subject).to receive(:method).with(:build_pending_shipment).and_return(method)
        allow(method).to receive(:arity).and_return(0)
      end

      it "state change to 'confirm'" do
        expect { subject.next_state }.to change { subject.state }.to eq('confirm')
      end

      it_behaves_like "next state is 'payment' if payment method is present"
    end

    context "when state is 'confirm'" do
      before { subject.state = 'confirm' }

      before do
        allow(subject).to receive(:complete!).and_return(true)

        # Override `arity` method for the stubbed `complete!` method.
        # refs: https://github.com/rspec/rspec-expectations/issues/583
        method = double('Method')
        allow(subject).to receive(:method).and_call_original
        allow(subject).to receive(:method).with(:complete!).and_return(method)
        allow(method).to receive(:arity).and_return(0)
      end

      it "state change to 'complete'" do
        expect { subject.next_state }.to change { subject.state }.to eq('complete')
      end

      it 'call the #complete! method' do
        expect(subject).to receive(:complete!).exactly(1).times.and_return(true)
        subject.next_state
      end
    end
  end
end
