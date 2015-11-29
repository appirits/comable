module Comable
  class Image < ActiveRecord::Base
    include Comable::Liquidable

    mount_uploader :file, Comable::ImageUploader

    belongs_to :product, class_name: Comable::Product.name, touch: true

    liquid_methods :url

    delegate :url, to: :file, allow_nil: true
    delegate :current_path, to: :file, allow_nil: true
    delegate :identifier, to: :file, allow_nil: true
  end
end
