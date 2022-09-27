json.extract! course, :id, :course_number, :sections, :number_of_students, :created_at, :updated_at
json.url course_url(course, format: :json)
