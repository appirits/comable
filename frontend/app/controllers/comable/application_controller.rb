module Comable
  class ApplicationController < ActionController::Base
    include Comable::ApplicationHelper

    protect_from_forgery with: :exception
  end
end
