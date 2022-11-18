class StudentEntries
    attr_accessor :records

    def initializeUsingStudentModel student
        @records = Set[student]
    end
end