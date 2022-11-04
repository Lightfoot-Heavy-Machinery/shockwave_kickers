module StudentsHelper

    FILTER_PARAMS = %i[course_id column direction].freeze

    scope :by_course_id, ->(query) { where('students.course_id ilike ?', "%#{query}%") }

    def self.filter(filters)
      Student.includes(:course_id)
            .by_course_id(filters['course_id'])
            .order("#{filters['column']} #{filters['direction']}")
    end
end
