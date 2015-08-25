class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :college_id
      t.text :text
      t.integer :votes_up
      t.integer :votes_down
      t.boolean :approved
      t.boolean :school_specific

      t.timestamps
    end

    add_index :posts, :created_at, name: 'posts_created_idx'
    add_index :posts, :approved, name: 'posts_approved_idx'
  end
end
