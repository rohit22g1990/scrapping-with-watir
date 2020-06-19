require_relative './scrapper'
require 'active_record'
require_relative './models/scrapped_data'
require_relative '../db/db_connection'
require 'watir'

Scrapper.new 'https://www.oyorooms.com'
