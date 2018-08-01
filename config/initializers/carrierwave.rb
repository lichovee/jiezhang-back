module CarrierWave
  module RMagick
    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

  end
end

CarrierWave.configure do |config|
	config.permissions = 0666
  config.directory_permissions = 0777
  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false
end