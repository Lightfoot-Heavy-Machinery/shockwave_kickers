json.extract! student, :firstname, :lastname, :uin, :email, :class_id, :classification, :major, :notes, :tags
json.url student_url(student, format: :json)
