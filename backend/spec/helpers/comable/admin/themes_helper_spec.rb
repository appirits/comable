describe Comable::Admin::ThemesHelper do
  subject { helper }

  describe '#editable?' do
    it 'should returns true when params[:path] is not blank' do
      allow(helper).to receive(:params).and_return(path: 'path/to/file')
      expect(subject.editable?).to eq(true)
    end

    it 'should returns false when params[:path] is blank' do
      allow(helper).to receive(:params).and_return(path: nil)
      expect(subject.editable?).to eq(false)
    end
  end

  describe '#display_directory_tree' do
    it 'should returns valid html elements' do
      theme = create(:theme)
      assign(:theme, theme)
      expect(subject.display_directory_tree(root: [foo: ['bar']])).to eq(<<-HTML.delete("\n").strip.gsub(/(:?>\s+<)/, '><'))
        <dl>
          <dt>foo</dt>
          <dl>
            <dd>
              <a href="/comable/admin/themes/#{theme.name}/file/foo/bar">bar</a>
            </dd>
          </dl>
        </dl>
      HTML
    end
  end

  describe '#liquidable_models' do
    before do
      Comable.const_set(:DummyModel, Class.new)
      Comable::DummyModel.const_set(:LiquidDropClass, Class.new)
    end

    after do
      Comable::DummyModel.send(:remove_const, :LiquidDropClass)
      Comable.send(:remove_const, :DummyModel)
    end

    it 'should returns the array that include Comable::DummyModel' do
      expect(subject.liquidable_models).to include(Comable::DummyModel)
    end
  end
end
