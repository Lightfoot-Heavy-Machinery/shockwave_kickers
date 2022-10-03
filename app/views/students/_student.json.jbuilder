json.extract! student, :firstname, :lastname, :uin, :email, :classification, :notes
json.url student_url(student, format: :json)
