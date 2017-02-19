class Post  < ApplicationRecord
	belongs_to :user
	belongs_to :college, required: false
	validates :text, presence: true

	scope :approved, -> { where(approved: true) }
	
	def self.default_scope
    select('posts.*', 'colleges.name AS college_name', 'users.name AS user_name').joins('LEFT OUTER JOIN colleges ON posts.college_id = colleges.id').joins('LEFT OUTER JOIN users ON users.id = posts.user_id')
 	end

  def self.visible_to_user(user)
    if user.present? && user.college.present?
      where(['school_specific = false OR (school_specific = true AND colleges.name = ?)', user.college.name])
    else
      where(school_specific: false)
    end
  end
end
