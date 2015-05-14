describe 'comable/admin/trackers/new' do
  let(:tracker) { FactoryGirl.build(:tracker) }

  before { assign(:tracker, tracker) }

  it 'renders new tracker form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_trackers_path, 'post'
  end
end
