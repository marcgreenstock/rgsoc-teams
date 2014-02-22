class SponsorsCreate < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :emails
      t.string :kind
      t.string :url
      t.timestamps
    end
  end
end
