class ImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "#{model.class.to_s.underscore}/#{model.id}"
  end
end
