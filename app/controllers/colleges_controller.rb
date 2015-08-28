class CollegesController < ApplicationController
	def show
		@college = College.find_by_name params[:id]
		gon.post_params = {
			approved: true,
			order: 'posts.created_at DESC',
			school: params[:id]
		}
	end
end
