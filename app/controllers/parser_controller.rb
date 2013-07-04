class ParserController < ApplicationController
	require 'nokogiri'
	require 'open-uri'

	def index
		@unparsed = []
		@parsed = []
		@questionable = []
		@rclasses = Rclass.all
		@rclasses.each do |rclass|
			# puts "#{rclass.name}: #{rclass.id}"
			# puts Rmethod.where('rclass_id = ? AND label IS NOT NULL',rclass.id).inspect
			#THIS ISNT WORKING FOR SOME REASON (below)
			@parsed = Rclass.where("name not like ?", "%::%")
			# if rclass.name.index('::')
			# 	@questionable << rclass
			# 	puts "#{rclass.name} is questionable"
			# elsif Rmethod.where('rclass_id = ? AND label IS NOT NULL',rclass.id) != []
			# 	puts "#{rclass.name} has been parsed"
			# 	@parsed << rclass
			# else
			# 	@unparsed << rclass
			# end
		end
	end
	def ohno
		log = YAML.load_file( "data.yml")
		log["rclasses"]["records"].each do |x|
			puts x[1]
		end
		redirect_to '/'

	end
	def parse
		@rclass = Rclass.find_by_name(params[:class_url][0..-6])
		unless @rclass
			puts "*"*50
			puts "*****NO CLASS FOUND FOR #{params[:class_url][0..-6]}"
			redirect_to '/'
		end
		@doc = Nokogiri::HTML(open('http://ruby-doc.org/core-2.0/'+params[:class_url]))
		puts "in #{params[:class_url]}"
		@doc.css('.method-callseq').each do |rmethod|
			rm = Rmethod.create(name: rmethod.content.gsub(/\s{2,}/," "))
			@rclass.rmethods << rm
			puts "#{rm.name} added to #{@rclass.name}"
		end
		if @rclass.rmethods != []
			flash[:alert] = "#{@rclass.name} added (#{@rclass.rmethods.length} methods)"
			redirect_to '/'
		else
			puts "NO METHODS ************************************"
			Rclass.find_by_name(@rclass.name).update_attributes(:name => @rclass.name + " ::none :(")
				flash[:alert] = "#{@rclass.name} added (no methods)"
				redirect_to '/'
			end
			# puts "WE HAVE RMETH: #{@rclass.rmethods.inspect}"
					# else
			# puts "***"*10
			# @rclass.name += " ::no methods :("
				# redirect_to '/'

			# end

		# end
	end
	def parse_label
		@rclass = Rclass.find_by_name(params[:class_url][0..-6])
		unless @rclass
			puts "*"*50
			puts "*****NO CLASS FOUND FOR #{params[:class_url][0..-6]}"
			redirect_to '/'
		end
		@doc = Nokogiri::HTML(open('http://ruby-doc.org/core-2.0/'+params[:class_url]))
		puts "in #{params[:class_url]}"
		@doc.css('.method-callseq').each do |rmethod|
			label = rmethod.parent.next_element.at('p')
			if label
				puts @rclass.name + "#" + rmethod.content.gsub(/\s{2,}/," ")
				@addTo = Rmethod.find_by_name(@rclass.name + "#" + rmethod.content.gsub(/\s{2,}/," "))
				puts "adding #{label.inner_text} to #{@addTo.name}"

				@addTo.update_attributes(:label => label.inner_text)
			else
				puts "adding nothing to #{rmethod.content.gsub(/\s{2,}/," ")}"
			end
			# puts "LABEL for #{rmethod.content.gsub(/\s{2,}/," ")}: #{label}"
		end
		puts "BYE BYE NOW ************************************"
		redirect_to '/'
	end
	def show
		@rclass = Rclass.find_by_name(params[:name])
		@parsed = Rclass.where("name not like ?", "%::%")
	end
	def data
		# @lotr = [
		# 	{"label"=>"Aragorn", "actor"=>"Viggo Mortensen"},
		# 	{"label"=>"Arwen", "actor"=>"Liv Tyler"},
		# 	{"label"=>"Bilbo Baggins", "actor"=>"Ian Holm"},
		# 	{"label"=>"Boromir", "actor"=>"Sean Bean"},
		# 	{"label"=>"Frodo Baggins", "actor"=>"Elijah Wood"},
		# 	{"label"=>"Gandalf", "actor"=>"Ian McKellen"},
		# 	{"label"=>"Gimli", "actor"=>"John Rhys-Davies"},
		# 	{"label"=>"Gollum", "actor"=>"Andy Serkis"},
		# 	{"label"=>"Legolas", "actor"=>"Orlando Bloom"},
		# 	{"label"=>"Meriadoc Merry Brandybuck", "actor"=>"Dominic Monaghan"},
		# 	{"label"=>"Peregrin Pippin Took", "actor"=>"Billy Boyd"},
		# 	{"label"=>"Samwise Gamgee", "actor"=>"Sean Astin"}
		# ]
		# @lotr.keep_if {|x| x['label'].downcase.index(params[:name_startsWith].downcase)}
		@rmethods = Rmethod.where("name ilike ?", "%#{params[:name_startsWith]}%").limit(params[:maxRows]).select("name, rclass_id, label")
		puts "*******************SAMPLE of #{@rmethods.class} full of stuff #{@rmethods[0].class}"
		puts Rmethod.find(3)['label']
		puts @rmethods.inspect
		@data = @rmethods.map { |x| { 'name' => x['name'], 'label' => x['label'], 'rclassName' => Rclass.find(x['rclass_id'])['name']}}
		puts @data[2]
		# @rmethods.each do |rmeth|
		# 	rmeth['rclass_id'] = Rclass.find(rmeth['rclass_id'])
		# end
		# puts @data.inspect
		puts "*"*50
		render :json => @data
	end
end