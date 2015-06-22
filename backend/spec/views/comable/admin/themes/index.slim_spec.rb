describe 'comable/admin/themes/index' do
  helper Comable::ApplicationHelper

  let!(:themes) { create_list(:theme, 2) }

  before { assign(:themes, (Rails::VERSION::MAJOR == 3) ? Comable::Theme.scoped : Comable::Theme.all) }

  it 'renders a list of themes' do
    render
    expect(rendered).to include(*themes.map(&:name))
  end
end
