describe 'comable/admin/themes/new' do
  let(:theme) { build(:theme) }

  before { assign(:theme, theme) }

  it 'renders new theme form' do
    render
    assert_select 'form[action=?][method=?]', comable.admin_themes_path, 'post'
  end
end
