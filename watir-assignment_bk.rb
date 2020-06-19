require 'watir'

class WebScrapping

	def initialize
		@browser = Watir::Browser.new
		@site_to_crawl = 'https://www.oyorooms.com'
		scrap_data
		
	end

	def scrap_data
		@browser.goto site_to_crawl
		navigate_to_listing_page
		prepare_scrapped_data
		@browser.close
	end

	def prepare_scrapped_data
		@hotels = Array.new
		browser.divs(class: 'hotelCardListing__descriptionWrapper').each do |hotel|
		
			hotelHash = Hash.new

			if !hotel.h3.text.nil?
					hotelHash['name'] = hotel.h3.text
					hotelHash['price'] = hotel.span(class: 'listingPrice__finalPrice').text
			end
			
			if !hotelHash.empty?
					@hotels << hotelHash
			end
			puts "Hotels are here:"
			puts @hotels

		end
	end


	def navigate_to_listing_page

		@browser.text_field(id: 'autoComplete__home').set 'Pune'
		@browser.div(class: 'geoSuggestionsList__container').divs.first.click
		@browser.button(class: 'searchButton--home').click
		@browser.div(:class => 'hotelCardListing__descriptionWrapper').wait_until(&:present?)
	end

end


# site_to_crawl = 'https://www.oyorooms.com'
# browser.goto site_to_crawl

# browser.text_field(id: 'autoComplete__home').set 'Pune'
# browser.div(class: 'geoSuggestionsList__container').divs.first.click
# browser.button(class: 'searchButton--home').click

# browser.div(:class => 'hotelCardListing__descriptionWrapper').wait_until(&:present?)

# hotels = Array.new
# browser.divs(class: 'hotelCardListing__descriptionWrapper').each do |hotel|
#   hotelHash = Hash.new
# 	if !hotel.h3.text.nil?
# 			hotelHash['name'] = hotel.h3.text
# 			hotelHash['price'] = hotel.span(class: 'listingPrice__finalPrice').text
# 	end
	
# 	if !hotelHash.empty?
# 			hotels << hotelHash
# 	end
# end

# puts "Hotels List: "
# puts hotels


# browser.close




1. To update Node Js
		- sudo npm cache clean -f
		- sudo npm install -g n
		- sudo n stable