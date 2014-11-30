describe Comable::OrderMailer do
  describe 'instructions' do
    let!(:store) { FactoryGirl.create(:store, :email_activate) }
    let(:order) { FactoryGirl.build(:order, :with_addresses, order_deliveries: [order_delivery]) }
    let(:order_delivery) { FactoryGirl.build(:order_delivery, order_details: [order_detail]) }
    let(:order_detail) { FactoryGirl.build(:order_detail, :sku, quantity: 2) }
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

    it 'assigns @order' do
      expect(mail.body.encoded).to include(order.bill_full_name)
    end

    it 'renders the product name with sku' do
      expect(mail.body.encoded).to include(order_detail.stock.name_with_sku)
    end
  end
end
