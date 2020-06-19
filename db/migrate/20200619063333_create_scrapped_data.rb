class CreateScrappedData < ActiveRecord::Migration[6.0]
  def change
    create_table :scrapped_data do |t|
      t.string :hotel_name 
      t.float :price
      t.timestamps
    end
  end
end
