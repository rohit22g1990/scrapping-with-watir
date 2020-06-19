class Scrapper
	def browse_website(site_to_crawl)
		@browser = Watir::Browser.new
		@browser.goto site_to_crawl

		@browser.text_field(id: 'autoComplete__home').set 'Pune'
		@browser.div(class: 'geoSuggestionsList__container').divs.first.click
		@browser.button(class: 'searchButton--home').click

		@browser.div(:class => 'hotelCardListing__descriptionWrapper').wait_until(&:present?)
	end

	def prepare_scrap_data
		hotels = Array.new
		@browser.divs(class: 'hotelCardListing__descriptionWrapper').each do |hotel|
			hotel_hash = Hash.new
			
			unless hotel.h3.text.nil?
				hotel_hash['hotel_name'] = hotel.h3.text
				hotel_hash['price'] = hotel.span(class: 'listingPrice__finalPrice').text.delete('a-zA-Z₹').to_f
			end

			hotels << hotel_hash unless hotel_hash.empty?
		end
		
		hotels
	end

	def scrap_data_of_url(site_to_crawl)
		browse_website(site_to_crawl)
		scrap_data = prepare_scrap_data
		
		if !scrap_data.empty? && ScrappedData.create(scrap_data)
			puts "Records scrapped successfully"
		else
			puts "Oops! Something went wrong"
		end
		@browser.close
	end 
end