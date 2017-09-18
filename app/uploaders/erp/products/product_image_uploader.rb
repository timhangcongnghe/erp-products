# encoding: utf-8
module Erp
  module Products
    class ProductImageUploader < CarrierWave::Uploader::Base

      # Include RMagick or MiniMagick support:
      # include CarrierWave::RMagick
      include CarrierWave::MiniMagick

      # Choose what kind of storage to use for this uploader:
      storage :file
      # storage :fog

      # Override the directory where uploaded files will be stored.
      # This is a sensible default for uploaders that are meant to be mounted:
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end

      # Provide a default URL as a default if there hasn't been a file uploaded:
      # def default_url
      #   # For Rails 3.1+ asset pipeline compatibility:
      #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
      #
      #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
      # end

      # Process files as they are uploaded:
      # process :scale => [200, 300]
      #
      # def scale(width, height)
      #   # do something
      # end

      # Create different versions of your uploaded files:
      # version :thumb do
      #   process :resize_to_fit => [50, 50]
      # end

      # Add a white list of extensions which are allowed to be uploaded.
      # For images you might use something like this:
      # def extension_white_list
      #   %w(jpg jpeg gif png)
      # end

      # Override the filename of the uploaded files:
      # Avoid using model.id or version_name here, see uploader/store.rb for details.
      # def filename
      #   "something.jpg" if original_filename
      # end

      # For backend list
			version :small do
				process :resize_to_fill => [120, 120]
			end

			version :medium do
				process :resize_to_fill => [300, 300]
			end

			# thumbnails
			version :thumb445 do
				process :resize_and_pad => [445, 445, "#FFFFFF", "Center"] # resize_to_fill => [600, 600]
			end

			version :thumb550 do
				process :resize_and_pad => [550, 550, "#FFFFFF", "Center"] # resize_to_fill => [600, 600]
			end
			
			version :thumb550 do
				process :resize_and_pad => [650, 650, "#FFFFFF", "Center"] # resize_to_fill => [600, 600]
			end

			# thumbnails
			version :thumb268 do
				process :resize_and_pad => [268, 268, "#FFFFFF", "Center"] # resize_to_fill => [193, 193]
			end

			# thumbnails
			version :thumb193 do
				process :resize_and_pad => [193, 193, "#FFFFFF", "Center"] # resize_to_fill => [193, 193]
			end

			# thumbnails
			version :thumb170 do
				process :resize_and_pad => [170, 170, "#FFFFFF", "Center"] # resize_to_fill => [193, 193]
			end

			# thumbnails
			version :thumb99 do
				process :resize_and_pad => [99, 99, "#FFFFFF", "Center"] # resize_to_fill => [193, 193]
			end

			# thumbnails
			version :thumb75 do
				process :resize_and_pad => [75, 75, "#FFFFFF", "Center"] # resize_to_fill => [193, 193]
			end
    end
  end
end
