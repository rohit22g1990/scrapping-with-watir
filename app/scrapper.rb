class Scrapper

	def initialize(site_to_crawl, city)
		@browser = Watir::Browser.new
		Selenium::WebDriver.logger.level = :error
		@site_to_crawl = site_to_crawl
		@city = city
	end 
	
	def browse_website
		@browser.goto @site_to_crawl
		@browser.text_field(id: 'autoComplete__home').set @city
		@browser.div(class: 'geoSuggestionsList__container').divs.first.click
		
		@browser.div(:class => 'geoSuggestionsList__container').wait_until(&:present?)
		
		# Open Datepicker
		@browser.div(:class => "datePickerDesktop__checkInOut").click

		# select month 
		@browser.select(class: 'DateRangePicker__MonthHeaderSelect').select('9')
		
		# select date
		@browser.spans(class: 'DateRangePicker__DateLabel').each do |element|
			element.click if element.text == '6'
			if element.text == '9'
				element.click
				break
			end
		end
		
		# Open Datepicker
		@browser.div(class: "guestRoomPicker--home").click
		
		@browser.span(:class => 'guestRoomPickerPopUp__plus').wait_until(&:present?)

		@browser.span(:class => "guestRoomPickerPopUp__plus").click
		
		# Click Search Button
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
