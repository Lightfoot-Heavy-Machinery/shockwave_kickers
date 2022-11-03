json.extract! student, :firstname, :lastname, :uin, :email, :course_id, :classification, :major, :notes, :tags, :image
json.url student_url(student, format: :json)
