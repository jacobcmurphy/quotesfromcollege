class CreateUsers < ActiveRecord::Migration
  def change
  	execute "create extension fuzzystrmatch"
  	execute "create extension pg_trgm"

    create_table :users do |t|
      t.string  :name
      t.integer :level, default: 0
      t.string  :image
      t.integer :college_id

      t.timestamps
    end
  end
end
