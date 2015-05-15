describe 'comable/admin/trackers/edit' do
  let(:tracker) { create(:tracker) }

  before { assign(:tracker, tracker) }

  it 'renders the edit tracker form' do
    render
    assert_select 'form[action=?]', comable.admin_tracker_path(tracker)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end
end
