class CollegesController < ApplicationController
	def show
		@college = College.find_by_name params[:id]
		@meta_hash = {
			title: "Quotes Overheard at #{@college.name} | Quotes From College",
			url: college_url(@college),
			description: "Come and read the funny and ridiculous quotes overhead at #{@college.name}."
		}
		gon.post_params = {
			approved: true,
			order: 'posts.created_at DESC',
			school: params[:id]
		}
	end

	def names
		name = params[:name]
		names = name ? College.where("lower(name) LIKE ?", "%#{name.downcase}%").pluck(:name) : []

		respond_to do |format|
	    	format.html { render partial: 'names', locals: { names: names } }
		end
	end
end