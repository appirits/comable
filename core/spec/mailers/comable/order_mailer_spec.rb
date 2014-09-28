describe Comable::OrderMailer do
  describe 'instructions' do
    let!(:store) { FactoryGirl.create(:store, :email_activate) }
    let(:order) { FactoryGirl.build(:order, order_deliveries: [order_delivery]) }
    let(:order_delivery) { FactoryGirl.build(:order_delivery, order_details: [order_detail]) }
    let(:order_detail) { FactoryGirl.build(:order_detail, quantity: 2) }
    let(:mail) { described_class.complete(order) }

    before { order.complete }

    it 'renders the subject' do
      expect(mail.subject).to match(order.code)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([order.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([store.email_sender])
    end

    it 'assigns @order.name' do
      expect(mail.body.encoded).to match(order.full_name)
    end
  end
end
