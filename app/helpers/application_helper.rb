module ApplicationHelper
	def states
		College.order('state ASC').pluck('DISTINCT state')
	end
end
