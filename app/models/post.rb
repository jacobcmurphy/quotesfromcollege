class Post  < ActiveRecord::Base
	belongs_to :user
	belongs_to :college
	validates_presence_of :college

	# loofah-activerecord to remove html from post bodies
	html_fragment :text, scrub: :prune

	scope :approved, -> { where(approved: true) }
	
	def self.default_scope
 	   select('posts.*', 'colleges.name AS college_name', 'users.name AS user_name').joins(:college).joins("LEFT OUTER JOIN users ON users.id = posts.user_id")
 	end

  def self.visible_to_user(user)
    if user.present?
      where(['school_specific = false OR (school_specific = true AND colleges.name = ?)', user.college.name])
    else
      where(school_specific: false)
    end
  end
end
