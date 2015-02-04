describe 'comable/admin/categories/index' do
  let!(:categories) { FactoryGirl.create_list(:category, 2) }

  before { assign(:categories, (Rails::VERSION::MAJOR == 3) ? Comable::Category.scoped : Comable::Category.all) }

  it 'renders a list of categories' do
    render
    expect(rendered).to include(*categories.map(&:name))
  end
end
