describe Comable::Admin::OrdersController do
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
end
