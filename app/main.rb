require_relative './scrapper'
require 'active_record'
require_relative './models/scrapped_data'
require_relative '../db/db_connection'
require 'watir'


scrapper_obj = Scrapper.new
scrapper_obj.scrap_data_of_url 'https://www.oyorooms.com'