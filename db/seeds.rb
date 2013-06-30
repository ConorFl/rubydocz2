# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'nokogiri'
require 'open-uri'

# doc = Nokogiri::HTML(open('http://ruby-doc.org/core-2.0/Hash.html'))
# doc.css('#classindex-section li').each do |ele|
# 	x = Rclass.create(name: ele.content)
# 	puts x.name
# end

# log = YAML.load_file( "data.yml")
# log = log["rclasses"]
 	
# puts log.inspect
# log["records"].each do |x|
# 	Rclass.create(:name => x[1])
# 	puts x[1]+" created"
# end

log = YAML.load_file( "data.yml")
log["rmethods"]["records"].each do |x|

	new_method = Rmethod.create(:name => x[1], :label => x[5])
	rclass = Rclass.find_by_name(x[1][0,x[1].index('#')])
	rclass.rmethods << new_method
	puts "OOOOH NOOOOO #{x[1]} method has no class" unless rclass
	puts x[1]+" created"
end