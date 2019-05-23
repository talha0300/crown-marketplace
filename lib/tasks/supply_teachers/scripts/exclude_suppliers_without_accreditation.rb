#!/usr/bin/env ruby

require 'json'

def exclude_suppliers_without_accreditation
  suppliers = JSON.parse(File.read('./lib/tasks/supply_teachers/output/data_merged.json'))
  suppliers_with_accreditation = suppliers.select { |s| s['accreditation'] }

  File.open('./lib/tasks/supply_teachers/output/data_only_accredited.json.tmp', 'w') do |f|
    f.puts JSON.pretty_generate(suppliers_with_accreditation)
  end
end
