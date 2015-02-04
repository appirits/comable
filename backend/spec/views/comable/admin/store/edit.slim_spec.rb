describe 'comable/admin/store/edit' do
  context 'when sotre is persisted' do
    let(:store) { FactoryGirl.create(:store) }

    before { assign(:store, store) }

    it 'renders the edit store form with put method' do
      render
      assert_select 'form[action=?]', comable.admin_store_path
      assert_select 'input[name=_method][value=?]', 'patch'
    end
  end

  context 'when sotre is not persisted' do
    let(:store) { FactoryGirl.build(:store) }

    before { assign(:store, store) }

    it 'renders the edit store form with put method' do
      render
      assert_select 'form[action=?]', comable.admin_store_path
      assert_select 'input[name=_method][value=?]', 'patch'
    end
  end
end
