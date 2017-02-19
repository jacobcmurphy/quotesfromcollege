class AddDefaultsToPosts < ActiveRecord::Migration
  def up
    change_column_default :posts, :votes_up, 0
    change_column_default :posts, :votes_down, 0
    change_column_default :posts, :user_id, 0
    change_column_default :posts, :approved, false
    change_column_default :posts, :school_specific, false
  end
end
