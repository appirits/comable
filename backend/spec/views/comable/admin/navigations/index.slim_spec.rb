describe 'comable/admin/navigations/index' do
  before do
    create_list(:navigation, 2, navigation_items: [create(:navigation_item)])
  end
  let!(:navigations) { Comable::Page.all }
  let(:q) { Comable::Page.ransack }

  before { assign(:q, q) }
  before { assign(:navigations, q.result.page(1)) }

  it 'renders a list of navigations' do
    render
    expect(rendered).to include(*navigations.map(&:name))
  end
end
