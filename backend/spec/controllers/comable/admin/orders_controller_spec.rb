describe Comable::Admin::OrdersController do
  sign_in_admin

  let(:comable) { controller.comable }

  describe 'GET index' do
    it 'assigns all orders as @orders' do
      order = FactoryGirl.create(:order, :completed)
      get :index
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe 'GET show' do
    it 'assigns the requested order as @order' do
      order = FactoryGirl.create(:order, :completed)
      get :show, id: order.to_param
      expect(assigns(:order)).to eq(order)
    end
  end

  describe 'GET export' do
    it 'exports the csv file' do
      order = FactoryGirl.create(:order, :completed)
      order_item = FactoryGirl.create(:order_item, order: order)
      get :export, format: :csv
      expect(response.body).to include(order.code)
      expect(response.body).to include(order.bill_address.first_name)
      expect(response.body).to include(order.bill_address.family_name)
      expect(response.body).to include(order_item.code)
    end

    it 'exports the xlsx file' do
      order = FactoryGirl.create(:order, :completed)
      FactoryGirl.create(:order_item, order: order)
      get :export, format: :xlsx
      expect(response.content_type).to eq(Mime::XLSX)
    end
  end
end
