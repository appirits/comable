describe 'comable/admin/pages/index' do
  before do
    create(:page, slug: 'test1')
    create(:page, slug: 'test2')
  end
  let!(:pages) { Comable::Page.all }
  let(:q) { Comable::Page.ransack }

  before { assign(:q, q) }
  before { assign(:pages, q.result.page(1)) }

  it 'renders a list of pages' do
    render
    expect(rendered).to include(*pages.map(&:title))
  end
end
