describe 'comable/admin/orders/edit' do
  let(:order) { create(:order, :completed) }

  before { assign(:order, order) }

  it 'renders the edit product form' do
    render
    assert_select 'form[action=?]', comable.admin_order_path(order)
    assert_select 'input[name=_method][value=?]', (Rails::VERSION::MAJOR == 3) ? 'put' : 'patch'
  end

  pending 'with #order_items' do
    let(:order_item) { build(:order_item) }

    before { order.order_items << order_item }

    it 'renders the fields for OrderItem' do
      render
      assert_select 'form input' do
        assert_select ':match("id", ?)', /order_order_items_attributes_\d_id/ do
          assert_select '[type=hidden]'
          assert_select '[value=?]', order_item.id.to_s
        end
      end
    end
  end
end
