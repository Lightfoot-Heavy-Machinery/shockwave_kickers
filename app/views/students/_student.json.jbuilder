json.extract! student, :firstname, :lastname, :uin, :email, :classification, :major, :notes
json.url student_url(student, format: :json)
