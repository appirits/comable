describe 'comable/admin/payment_methods/edit' do
  let(:payment_method) { FactoryGirl.create(:payment_method) }

  before { assign(:payment_method, payment_method) }

  it 'renders the edit payment_method form' do
    render
    assert_select 'form[action=?]', comable.admin_payment_method_path(payment_method)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
