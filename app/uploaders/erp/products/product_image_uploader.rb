module Erp
  module Products
    class ProductImageUploader < CarrierWave::Uploader::Base
      # Include RMagick or MiniMagick support:
      # include CarrierWave::RMagick
      include CarrierWave::MiniMagick

      storage :file
      # storage :fog
      
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

      # Start Backend
			version :small do
				process :resize_to_fill => [120, 120]
			end

			version :medium do
				process :resize_to_fill => [300, 300]
			end
      # End Backend
			
			#choose
			version :thumb193 do
				process :resize_and_pad => [193, 193, "#FFFFFF", "Center"]
			end
      
      #choose
			version :thumb445 do
				process :resize_and_pad => [445, 445, "#FFFFFF", "Center"]
			end
			
			#choose
			version :thumb650 do
				process :resize_and_pad => [650, 650, "#FFFFFF", "Center"] # resize_to_fill => [650, 650]
			end
    end
  end
end