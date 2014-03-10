require 'spec_helper'

describe Comable::ProductsController do
  render_views

  let (:product) { FactoryGirl.create(:product) }

  before { request }

  describe "GET 'index'" do
    let (:request) { get :index }
    its (:response) { should be_success }
  end

  describe "GET 'show'" do
    let (:request) { get :show, id: product.id }
    its (:response) { should be_success }
  end
end
