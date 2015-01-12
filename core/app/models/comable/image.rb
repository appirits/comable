module Comable
  class Image < ActiveRecord::Base
    mount_uploader :file, ImageUploader

    belongs_to :product, class_name: Comable::Product.name

    delegate :url, to: :file, allow_nil: true
    delegate :current_path, to: :file, allow_nil: true
    delegate :identifier, to: :file, allow_nil: true
  end
end
