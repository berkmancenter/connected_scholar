# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'SETTING UP DEFAULT USER LOGINS'
unless User.exists?(:email => 'admin@test.com')
  user = User.create! :name => "First User", :email => 'admin@test.com', :password => 'password', :password_confirmation => 'password'
  puts 'New user created: ' << user.name
end

unless User.exists?(:email => 'two@test.com')
  user = User.create! :name => "Second User", :email => 'two@test.com', :password => 'password', :password_confirmation => 'password'
  puts 'New user created: ' << user.name
end

User.where(:email => ['admin@test.com', 'two@test.com']).each do |u|
  u.approve!
  u.promote!
  u.save!
end
