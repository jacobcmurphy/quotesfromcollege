class Post  < ActiveRecord::Base
	belongs_to :user
	belongs_to :college
	validates_presence_of :college

	# loofah-activerecord to remove html from post bodies
	html_fragment :text, scrub: :prune

	scope :approved, -> { where(approved: true) }
	
	def self.with_associated
 	   select('posts.*', 'colleges.name AS college_name', 'users.name AS user_name').joins(:college).joins("LEFT OUTER JOIN users ON users.id = posts.user_id")
 	end
end
