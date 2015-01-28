describe 'comable/admin/customers/edit' do
  let(:customer) { FactoryGirl.create(:customer) }

  before { assign(:customer, customer) }

  it 'renders the edit customer form' do
    render
    assert_select 'form[action=?]', comable.admin_customer_path(customer)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
