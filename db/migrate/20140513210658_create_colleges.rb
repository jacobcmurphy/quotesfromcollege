class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :name
      t.string :state
    end
    add_index :colleges, :name, name: 'college_name_idx'
    add_index :colleges, :state, name: 'college_state_idx'
  end
end
