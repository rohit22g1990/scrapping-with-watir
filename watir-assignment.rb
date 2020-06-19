require 'watir'
require 'pg'

begin
	con = PG.connect( :hostaddr=>"127.0.0.1", :port=>5432, :dbname=>"scrapper", :user=>"postgres", :password=>"postgres")
rescue PG::Error => e
  puts e.message 
end
# con.exec("INSERT INTO scrapper_data (hotel_name, price) VALUES ('Roit', 5555555)")

browser = Watir::Browser.new

site_to_crawl = 'https://www.oyorooms.com'
browser.goto site_to_crawl

browser.text_field(id: 'autoComplete__home').set 'Pune'
browser.div(class: 'geoSuggestionsList__container').divs.first.click
browser.button(class: 'searchButton--home').click

browser.div(:class => 'hotelCardListing__descriptionWrapper').wait_until(&:present?)

hotels = Array.new
browser.divs(class: 'hotelCardListing__descriptionWrapper').each do |hotel|
  hotel_hash = Hash.new
	if !hotel.h3.text.nil?
		hotel_hash['name'] = hotel.h3.text
		hotel_hash['price'] = hotel.span(class: 'listingPrice__finalPrice').text.delete('a-zA-Z₹').to_f
	end
  if !hotel_hash.empty?
    hotels << hotel_hash
  end
end

# con.exec("INSERT INTO scrapper_data (hotel_name, price) VALUES ('#{hotel_hash['name']}', #{hotel_hash['price']})")

puts "Hotels List: "
puts hotels

query = "INSERT INTO scrapper_data (hotel_name, price) VALUES "

hotels.each do |data|
	query += "('#{data['name']}', #{data['price']}),"
end

con.exec(query.chomp(','))

puts query.chomp(',')

browser.close