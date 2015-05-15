describe 'comable/admin/payment_methods/index' do
  let!(:payment_methods) { create_list(:payment_method, 2) }

  before { assign(:payment_methods, Comable::PaymentMethod.page(1)) }

  it 'renders a list of payment_methods' do
    render
    expect(rendered).to include(*payment_methods.map(&:name))
  end
end
