module Comable
  module Importable
    extend ActiveSupport::Concern

    class Exception < StandardError
    end

    class UnknownFileType < Comable::Importable::Exception
    end

    class RecordInvalid < Comable::Importable::Exception
    end

    # from http://railscasts.com/episodes/396-importing-csv-and-excel
    module ClassMethods
      def import_from(file, primary_key: :code)
        spreadsheet = open_spreadsheet(file)
        read_spreadsheet(spreadsheet) do |header, row|
          attributes = attributes_from_header_and_row(header, row)
          record = find_by(primary_key => attributes[primary_key]) || new
          begin
            record.update_attributes!(attributes)
          rescue ActiveRecord::RecordInvalid => e
            raise RecordInvalid, "#{record.class.human_attribute_name(primary_key)} \"#{record.send(primary_key)}\": #{e.message}"
          end
        end
      end

      private

      def open_spreadsheet(file)
        case File.extname(file.original_filename)
        when '.csv' then Roo::CSV.new(file.path)
        when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
        when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
        else fail UnknownFileType, Comable.t('admin.unknown_file_type', filename: file.original_filename)
        end
      end

      def read_spreadsheet(spreadsheet)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          yield header, spreadsheet.row(i)
        end
      end

      def attributes_from_header_and_row(header, row)
        human_attributes = Hash[[header, row].transpose].to_hash
        human_attributes_to_attributes(human_attributes)
      end

      def human_attributes_to_attributes(human_attributes)
        comma_column_names.each.with_object({}) do |(key, _value), result|
          human_key = Comma::HeaderExtractor.value_humanizer.call(key.to_sym, self)
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
