class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new
    new_student.id =row[0]
    new_student.name =row[1]
    new_student.grade =row[2]
    new_student
    # create a new Student object given a row from the database
  end

  def self.all
    all_students = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(all_students).map { |student|
      self.new_from_db(student)
      }
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    find_name = <<-SQL
       SELECT * FROM students
        WHERE name = ?
        LIMIT 1
    SQL

    DB[:conn].execute(find_name,name).map do |student|
      self.new_from_db(student)
    end.first
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.count_all_students_in_grade_9
    count_it = <<-SQL
       SELECT count(students.id) FROM students
       WHERE grade = 9
    SQL

    DB[:conn].execute(count_it)
  end

  def self.students_below_12th_grade
    below_12 = <<-SQL
      SELECT students.name FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(below_12)
  end

  def self.first_x_students_in_grade_10(x)
    first_x_students = <<-SQL
      SELECT students.name FROM students
      WHERE grade=10
    SQL

    DB[:conn].execute(first_x_students).map do |student|
      self.new_from_db(student)
    end[0...x]
  end

  def self.first_student_in_grade_10
    first_x_students = <<-SQL
      SELECT * FROM students
      WHERE grade=10
    SQL

    DB[:conn].execute(first_x_students).map do |student|
      self.new_from_db(student)
    end.first
  end

  def self.all_students_in_grade_X(x)
    first_x_students = <<-SQL
      SELECT * FROM students
      WHERE grade= ?
    SQL

    DB[:conn].execute(first_x_students,x).map do |student|
      self.new_from_db(student)
    end
  end
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
