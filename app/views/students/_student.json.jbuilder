json.extract! student, :firstname, :lastname, :uin, :email, :course_id, :classification, :major, :notes, :tags
json.url student_url(student, format: :json)
