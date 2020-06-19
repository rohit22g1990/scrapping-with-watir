class Scrapper

	def initialize(site_to_crawl)
		@browser = Watir::Browser.new
		@site_to_crawl = site_to_crawl
		
	end 
	
	def browse_website
  	@browser.goto @site_to_crawl
		@browser.text_field(id: 'autoComplete__home').set 'Pune'
		@browser.div(class: 'geoSuggestionsList__container').divs.first.click
		@browser.button(class: 'searchButton--home').click
		@browser.div(:class => 'hotelCardListing__descriptionWrapper').wait_until(&:present?)
	end

	def scrap_data
		browse_website

		hotels = Array.new
		@browser.divs(class: 'hotelCardListing__descriptionWrapper').each do |hotel|
			hotel_hash = Hash.new
			
			unless hotel.h3.text.nil?
				hotel_hash['hotel_name'] = hotel.h3.text
				hotel_hash['price'] = hotel.span(class: 'listingPrice__finalPrice').text.delete('a-zA-Z₹').to_f
			end

			hotels << hotel_hash unless hotel_hash.empty?
		end
		
		if !hotels.empty? && ScrappedData.create(hotels)
			puts "Records scrapped successfully"
		else
			puts "Oops! Something went wrong"
		end
		
		close_browser
	end

	def close_browser
		@browser.close
	end
end