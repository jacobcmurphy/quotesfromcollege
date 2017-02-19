class College  < ApplicationRecord
	has_many :posts
	has_many :users
  has_many :source_numbers
	
	def to_param
		name
	end

	def self.names
		Rails.cache.fetch('colleges/name', expires_in: 12.hours) do
	    	self.order(:name).pluck(:name)
	    end
	end

	def self.states
		Rails.cache.fetch('colleges/states', expires_in: 12.hours) do
			self.order('state ASC').pluck('DISTINCT state')
		end
	end

	def self.in_state(state)
		self.where(state: state).order('name ASC')
	end
end
