describe 'comable/admin/trackers/index' do
  let!(:trackers) { FactoryGirl.create_list(:tracker, 2) }

  before { assign(:trackers, Comable::Tracker.page(1)) }

  it 'renders a list of trackers' do
    render
    expect(rendered).to include(*trackers.map(&:name))
  end
end
