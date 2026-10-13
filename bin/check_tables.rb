# encoding: utf-8
# check_tables.rb -- check the maintained name tables against units.json (see name_tables.rb)
#   ruby check_tables.rb [units.json] [tables]
require 'json'
require_relative 'name_tables'
units = JSON.parse(File.binread(ARGV[0] || 'units.json').force_encoding('UTF-8'))
r = NameTables.check(units, ARGV[1] || File.join(__dir__, 'tables'))
puts r.notes.map { |n| "note: #{n}" }
puts "names #{r.names.size}, entries #{r.entries.size}, compound expressions checked " \
     "#{r.entries.count { |e| e['checked'] }}, errors #{r.errors.size}"
puts r.errors
exit(r.errors.empty? ? 0 : 1)
