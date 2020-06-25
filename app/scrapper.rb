class Scrapper

	def initialize(site_to_crawl, city)
		@browser = Watir::Browser.new :chrome, headless: true
		Selenium::WebDriver.logger.level = :error
		@site_to_crawl = site_to_crawl
		@city = city
	end 
	
	def browse_website
		puts "Browsing the website" 
		@browser.goto @site_to_crawl
		@browser.text_field(id: 'autoComplete__home').set @city
		puts "City Set to #{@city}" 
		@browser.div(class: 'geoSuggestionsList__container').divs.first.click
		
		@browser.div(class: 'geoSuggestionsList__container').wait_until(&:present?)
		
		# Open Datepicker
		@browser.div(class: "datePickerDesktop__checkInOut").click
		
		
		select_date		
	
		# Open Rooms Guest 
		@browser.div(class: "guestRoomPicker--home").click
		
		@browser.span(class: 'guestRoomPickerPopUp__plus').wait_until(&:present?)
		
		# Add 1 Guest
		@browser.span(class: "guestRoomPickerPopUp__plus").click
		
		# Click Search Button
		@browser.button(class: 'searchButton--home').click
		
		@browser.div(class: 'hotelCardListing__descriptionWrapper').wait_until(&:present?)
	end

	def select_date
		# select month 
		start_month, start_date, end_month, end_date = '7', '2', '7', '3'
		
		@browser.select(class: 'DateRangePicker__MonthHeaderSelect').select(start_month)
		
		next_month_end_date = true unless start_month == end_month
		
		# select date
		next_month = false
		temp = Array.new
		@browser.spans(class: 'DateRangePicker__DateLabel').each do |element|
			# if temp.include?(element.text)
			# 	next_month = true 
			# else
			# 	temp.push(element.text) unless element.text.empty?
			# end
			temp.include?(element.text) ? next_month = true : temp.push(element.text) unless element.text.empty?

			element.click if element.text == start_date && next_month == false
			if (element.text == end_date && next_month_end_date == nil) || (element.text == end_date && next_month_end_date == true && next_month == true )
				element.click
				break
			end
		end
		puts "Date Selected from #{start_date}/#{start_month} to #{end_date}/#{end_month}" 
	end

	def scrap_data
		puts "Scrapping started for website: #{@site_to_crawl}"
		browse_website
		puts "Scrapping data in progress..."

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
