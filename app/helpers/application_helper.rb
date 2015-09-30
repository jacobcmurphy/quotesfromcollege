module ApplicationHelper
	def states
		College.order('state ASC').pluck('DISTINCT state')
	end

	def metadata(**options)
		title = options.fetch :title, 'Quotes From College'
		description = options.fetch :options, 'Share and read the ridiculous things you overhear at college.'
		extra_meta = options.fetch :extra_meta, {}
		url = options.fetch :url, 'http://www.quotesfromcollege.com/'
		img_path = options.fetch :img_path, image_url('favicon.ico')
		
		render partial: 'layouts/metadata', locals: {title: title, description: description, url: url, img_path: img_path, extra_meta: extra_meta}
	end
end
