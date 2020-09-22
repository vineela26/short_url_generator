class CreateLinkStats < ActiveRecord::Migration[6.0]
  def change
    create_table :link_stats do |t|
      t.integer :link_id
      t.string :ip_address
      t.string :country
      t.timestamps
    end
  end
end
