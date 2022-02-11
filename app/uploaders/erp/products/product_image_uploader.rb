module Erp
  module Products
    class ProductImageUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick

      storage :file
      
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

			version :small do
				process :resize_to_fill => [120, 120]
			end

			version :medium do
				process :resize_to_fill => [300, 300]
			end

			version :thumb193 do
				process :resize_and_pad => [193, 193, "#FFFFFF", "Center"]
			end
      
			version :thumb445 do
				process :resize_and_pad => [445, 445, "#FFFFFF", "Center"]
			end
			
			version :thumb650 do
				process :resize_and_pad => [650, 650, "#FFFFFF", "Center"]
			end

			version :thumb1500x1500 do
				process :resize_and_pad => [1500, 1500, "#FFFFFF", "Center"]
			end
    end
  end
end