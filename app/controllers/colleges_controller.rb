class CollegesController < ApplicationController
	def show
		@college = College.find_by_name params[:id]
		@meta_hash = {
			title: "Quotes Overheard at #{@college.name} | Heard In College",
			url: college_url(@college),
			description: "Come and read the funny and ridiculous quotes overhead at #{@college.name}."
		}
    @posts = Post.where(college_id: @college.id, approved: true).order('created_at DESC').page(params[:page_number])
	end

	def names
		name = params[:name]
		names = name ? College.where("lower(name) LIKE ?", "%#{name.downcase}%").pluck(:name) : []

		respond_to do |format|
	    	format.html { render partial: 'names', locals: { names: names } }
		end
	end
end
