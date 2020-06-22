require_relative './scrapper'
require 'active_record'
require_relative './models/scrapped_data'
require_relative '../db/db_connection'
require 'watir'


scrapper_obj = Scrapper.new('https://www.oyorooms.com', 'Pune')
scrapper_obj.scrap_data
