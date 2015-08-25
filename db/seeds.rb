puts 'Seeding schools'
College.destroy_all
require_relative 'load_school'
brandeis = College.find_by_name 'Brandeis University'

unless  Rails.env.production?
	User.destroy_all
	puts 'Seeding user'
	u=User.new(name: 'Jacob Murphy', level: 9001, college_id: brandeis.id, email: 'murphorum@gmail.com')
	u.password = 'password'
	u.password_confirmation = 'password'
	u.save!


	Post.destroy_all
	base = 1000
	puts 'Seeding posts'
	100.times{
		txt = base.to_s << ' -- ' << ('a'..'z').to_a.shuffle.join
		acc = [true, false].sample
		down = Random.new.rand(1..100)
		up = (acc) ? down + 20 : Random.new.rand(1..down)
		specific = [true, false].sample

		u.posts.create(id: base, text: txt, votes_up: up, votes_down: down, approved: acc, college_id: brandeis.id, school_specific: specific, created_at: Time.now, updated_at: Time.now)

		base += 1
	}
end
