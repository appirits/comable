describe Comable::OrderMailer do
  describe 'instructions' do
    let!(:store) { create(:store, :email_activate) }
    let(:order) { build(:order, :with_addresses, order_items: [order_item]) }
    let(:order_item) { build(:order_item, :sku, quantity: 2) }
    let(:mail) { described_class.complete(order) }

    before { order.complete }

    it 'renders the subject' do
      expect(mail.subject).to match(order.code)
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([order.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq([store.email])
    end

    it 'assigns @order' do
      expect(mail.body.encoded).to include(order.bill_full_name)
    end

    it 'renders the product name with sku' do
      expect(mail.body.encoded).to include(order_item.name)
    end
  end
end
