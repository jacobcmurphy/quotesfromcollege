class TwilioChanges < ActiveRecord::Migration
  def change
    add_column :posts, :from_phone, :string

    create_table :source_numbers do |t|
      t.string :phone_number, index: true
      t.integer :college_id, index: true
    end
  end
end
