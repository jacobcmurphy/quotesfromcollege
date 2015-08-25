class CollegesController < ApplicationController
	def show
		gon.post_params = {
			approved: true,
			order: 'posts.created_at DESC',
			school: params[:id]
		}
	end
end
