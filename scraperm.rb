require 'nokogiri'
require 'open-uri'
def parse(n)
	@rclass = Rclass.find_by_name(n[0..-6])
	@doc = Nokogiri::HTML(open('http://ruby-doc.org/core-2.0/'+n))
	@doc.css('.method-callseq').each do |rmethod|
		rm = Rmethod.create(name: rmethod.content.gsub(/\s{2,}/," "))
		@rclass.rmethods << rm
	end
end
@rclasses = []
Rclass.all.each |rclass|
@rclasses << rclass unless rclass.rmethods
end
@rclasses.each do |parse_me|
	parse(parse_me.name+".html")
end
