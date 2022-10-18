json.extract! course, :id, :course_name, :section, :teacher, :semester, :created_at, :updated_at
json.url course_url(course, format: :json)
