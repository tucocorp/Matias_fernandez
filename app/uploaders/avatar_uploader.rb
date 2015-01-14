# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    'uploads/users'
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    random_token = SecureRandom.hex.freeze
    ivar    = "@#{mounted_as}_secure_token"
    token   = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, random_token)
    
    token + File.extname(@filename) if original_filename
  end

  def default_url
    "/assets/default-avatar.jpg"
  end

  version :thumb do
    process :resize_to_fill => [50, 50]
  end

  version :medium do
    process :resize_to_fill => [92, 92]
  end
end
