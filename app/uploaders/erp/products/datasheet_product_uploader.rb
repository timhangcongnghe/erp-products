module Erp
  module Products
    class DatasheetProductUploader < CarrierWave::Uploader::Base
      storage :file
      
      def store_dir
        "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
      
      def extension_white_list
        %w(pdf)
      end
    end
  end
end