describe 'comable/admin/navigations/new' do
  let(:navigation) { build(:navigation, navigation_items: [create(:navigation_item)]) }

  before { assign(:navigation, navigation) }

  it 'renders new navigation form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_navigations_path, 'post'
  end
end
