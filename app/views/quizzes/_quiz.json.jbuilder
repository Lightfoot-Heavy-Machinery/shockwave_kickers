json.extract! quiz, :id, :course_id, :correct, :incorrect, :score, :longest_streak, :created_at, :updated_at, :completed
json.url quiz_url(quiz, format: :json)
