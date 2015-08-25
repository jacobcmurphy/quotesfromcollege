class College  < ActiveRecord::Base
	has_many :posts
	has_many :users

	def self.states
		self.order('state ASC').pluck('DISTINCT state')
	end

	def self.in_state(state)
		self.where(state: state).order('name ASC')
	end
end
