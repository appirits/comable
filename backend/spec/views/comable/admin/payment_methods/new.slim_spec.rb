describe 'comable/admin/payment_methods/new' do
  let(:payment_method) { FactoryGirl.build(:payment_method) }

  before { assign(:payment_method, payment_method) }

  it 'renders new payment_method form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_payment_methods_path, 'post'
  end
end
