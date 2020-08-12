module SpreadsheetImportHelper
  # Creates fake bulk upload spreadsheet.
  # Caveats:
  #   1. Only adds the sheets you ask for
  #   2. The sheets may not be in the same order as the real spreadsheet
  class FakeBulkUploadSpreadsheet
    def initialize
      @package = Axlsx::Package.new
      @sheets_added = []
    end

    OUTPUT_PATH = './tmp/test.xlsx'.freeze

    def write
      File.write(OUTPUT_PATH, @package.to_stream.read)
    end

    def add_building_sheet(buildings_details)
      name = 'Building Information'
      @sheets_added << name
      buildings = buildings_details.map(&:first)
      @package.workbook.add_worksheet(name: name) do |sheet|
        sheet.add_row(['Building Number'] + buildings.map.with_index { |_, i| "Building #{i + 1}" })
        sheet.add_row(['Building Name'] + buildings.map(&:building_name))
        sheet.add_row(['Building Description'] + buildings.map(&:description))
        sheet.add_row(['Building Address - Street'] + buildings.map(&:address_line_1))
        sheet.add_row(['Building Address - Town'] + buildings.map(&:address_town))
        sheet.add_row(['Building Address - Postcode'] + buildings.map(&:address_postcode))
        sheet.add_row(['Building Gross Internal Area (GIA) (sqm)'] + buildings.map(&:gia))
        sheet.add_row(['Building External Area (sqm)'] + buildings.map(&:external_area))
        sheet.add_row(['Building Type'] + buildings.map(&:building_type))
        sheet.add_row(['Building Type (other)'] + buildings.map(&:other_building_type))
        sheet.add_row(['Building Security Clearance'] + buildings.map(&:security_type))
        sheet.add_row(['Building Security Clearance (other)'] + buildings.map(&:other_security_type))
        sheet.add_row(['Status indicator:'] + buildings_details.map(&:last))
      end
    end

    def add_service_matrix_sheet(data)
      name = 'Service Matrix'
      @sheets_added << name

      @package.workbook.add_worksheet(name: name) do |sheet|
        sheet.add_row(%w[bish bosh bash])
      end
      puts ">>>>>>> add_service_matrix_sheet: #{data}"
    end

    def add_missing_sheets_from_template
      template_spreadsheet = Roo::Spreadsheet.open(FacilitiesManagement::SpreadsheetImporter::TEMPLATE_FILE_PATH,
                                                   extension: :xlsx)

      template_spreadsheet.sheets.each do |template_sheet_name|
        next if @sheets_added.include?(template_sheet_name)

        # Add sheet from template
        @package.workbook.add_worksheet(name: template_sheet_name) do |fake_sheet|
          # We have to use `each_row_streaming` for the `pad_cells` option, else blank cells are ignored
          template_spreadsheet.sheet(template_sheet_name).each_row_streaming(pad_cells: true) do |cell_objects|
            row_values = cell_objects.map { |cell_object| cell_object.nil? ? '' : cell_object.value } # Convert to simple array of values
            fake_sheet.add_row(row_values)
          end
        end
      end
    end
  end

  def bulk_upload_spreadsheet_builder(spreadsheet_path, buildings_details = [])
    package = Axlsx::Package.new
    package.workbook.add_worksheet(name: 'Instructions') do |sheet|
      9.times do
        sheet.add_row []
      end
      sheet.add_row ['Current status:', 'Ready to upload']
    end

    spreadsheet_buildings_builder(package, buildings_details)
    File.write(spreadsheet_path, package.to_stream.read)
  end

  private

  def spreadsheet_buildings_builder(package, buildings_details)
    buildings = buildings_details.map(&:first)
    package.workbook.add_worksheet(name: 'Building Information') do |sheet|
      sheet.add_row(['Building Number'] + buildings.map.with_index { |_, i| "Building #{i + 1}" })
      sheet.add_row(['Building Name'] + buildings.map(&:building_name))
      sheet.add_row(['Building Description'] + buildings.map(&:description))
      sheet.add_row(['Building Address - Street'] + buildings.map(&:address_line_1))
      sheet.add_row(['Building Address - Town'] + buildings.map(&:address_town))
      sheet.add_row(['Building Address - Postcode'] + buildings.map(&:address_postcode))
      sheet.add_row(['Building Gross Internal Area (GIA) (sqm)'] + buildings.map(&:gia))
      sheet.add_row(['Building External Area (sqm)'] + buildings.map(&:external_area))
      sheet.add_row(['Building Type'] + buildings.map(&:building_type))
      sheet.add_row(['Building Type (other)'] + buildings.map(&:other_building_type))
      sheet.add_row(['Building Security Clearance'] + buildings.map(&:security_type))
      sheet.add_row(['Building Security Clearance (other)'] + buildings.map(&:other_security_type))
      sheet.add_row(['Status indicator:'] + buildings_details.map(&:last))
    end
  end
end
