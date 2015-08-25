class PostChanger
    def self.clean_old_posts
        Post.where(approved: false).where("created_at < ?", 3.days.ago).destroy_all()
    end

    def self.update_posts
    	Post.where(approved: false).where("votes_up-votes_down > 20").update_all(approved: true)
    end
    puts "TEST"
	update_posts
    clean_old_posts
   
end