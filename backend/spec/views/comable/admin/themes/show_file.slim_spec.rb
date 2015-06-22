describe 'comable/admin/themes/show_file' do
  helper Comable::ApplicationHelper

  let(:theme) { build(:theme) }

  before { assign(:theme, theme) }
  before { allow(view).to receive(:params).and_return(path: 'path/to/file') }

  it 'renders the theme editor' do
    render
    assert_select '#comable-theme-editor'
  end

  it 'renders the source code' do
    code = 'Sample code!'
    assign(:code, code)
    render
    expect(rendered).to match(code)
  end
end
