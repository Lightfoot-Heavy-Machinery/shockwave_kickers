# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
    # User.create!([{email: "testUser", name:"testUser", password: "123456"}])

Tag.find_or_create_by(tag_name: 'Honor Council', teacher: 'csimpson2018@tamu.edu')
Tag.find_or_create_by(tag_name: 'Good Student', teacher: 'csimpson2018@tamu.edu')
Tag.find_or_create_by(tag_name: 'Disruptive', teacher: 'csimpson2018@tamu.edu')
Tag.find_or_create_by(tag_name: 'Quiet Workhorse', teacher: 'csimpson2018@tamu.edu')
Tag.find_or_create_by(tag_name: 'Former Grader/TA', teacher: 'csimpson2018@tamu.edu')