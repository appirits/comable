module Comable
  class Product < ActiveRecord::Base
    module Csvable
      extend ActiveSupport::Concern

      included do
        comma do
          name
          code
          price
          caption
          sku_h_item_name
          sku_v_item_name
        end
      end

      module ClassMethods
        # from http://railscasts.com/episodes/396-importing-csv-and-excel
        def import_from(file, primary_key: :code)
          spreadsheet = open_spreadsheet(file)
          read_spreadsheet(spreadsheet) do |header, row|
            human_attributes = Hash[[header, row].transpose].to_hash
            attributes = human_attributes_to_attributes(human_attributes)
            product = find_by(primary_key => attributes[primary_key]) || new
            product.update_attributes!(attributes)
          end
        end

        def open_spreadsheet(file)
          case File.extname(file.original_filename)
          when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
          when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
          when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
          else fail "Unknown file type: #{file.original_filename}"
          end
        end

        def read_spreadsheet(spreadsheet)
          header = spreadsheet.row(1)
          (2..spreadsheet.last_row).each do |i|
            yield header, spreadsheet.row(i)
          end
        end

        def human_attributes_to_attributes(human_attributes)
          comma_column_names.each.with_object({}) do |(key, _value), result|
            human_key = human_attribute_name(key)
            result[key.to_sym] = human_attributes[human_key] if human_attributes[human_key]
            result
          end
        end

        def comma_column_names(style = :default)
          header_extractor_class = Comma::HeaderExtractor.dup
          header_extractor_class.value_humanizer = -> (value, _model_class) { value.to_s }
          extract_with(header_extractor_class, style)
        end
      end
    end
  end
end
