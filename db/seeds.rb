# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# users = [
#     {:username => 'team_cluck_admin@gmail.com', :password => 'team_cluck_12345!'}
# ]

# users.each do |user|
#     User.create!(user)
# end

User.create(email: 'team_cluck_admin@gmail.com', password: 'team_cluck_12345!')

#fake data for testing
#User.create(email: 'oliphcal000@tamu.edu', password: 'Haudi')

course_names = ["CSCE 121", "CSCE 221", "CSCE 313", "CSCE 315", "CSCE 310", "CSCE 431", "CSCE 465"]
sections = ["500" , "501" , "502" , "503" , "504" , "505" , "506" , "507" , "508" , "509", "590" , "591" , "592" , "593" , "594" , "595" , "596" , "597" , "598"] 
semesters = ["Fall 2022", "Spring 2023", "Fall 2023", "Spring 2024"]

i = 0
while i < 20 do
    Course.create(course_name: course_names.sample, section: sections.sample, semester: semesters.sample, teacher: 'team_cluck_admin@gmail.com')
    i = i + 1
end

last_names = ['Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Miller', 'Davis', 'Garcia', 'Rodriguez', 'Wilson', 'Martinez', 'Anderson', 'Taylor', 'Thomas', 'Hernandez', 'Moore', 'Martin', 'Jackson', 'Thompson', 'White', 'Lopez', 'Lee', 'Gonzalez', 'Harris', 'Clark', 'Lewis', 'Robinson', 'Walker', 'Perez', 'Hall', 'Young', 'Allen', 'Sanchez', 'Wright', 'King', 'Scott', 'Green', 'Baker', 'Adams', 'Nelson', 'Hill', 'Ramirez', 'Campbell', 'Mitchell', 'Roberts', 'Carter', 'Phillips', 'Evans', 'Turner', 'Torres', 'Parker', 'Collins', 'Edwards', 'Stewart', 'Flores', 'Morris', 'Nguyen', 'Murphy', 'Rivera', 'Cook', 'Rogers', 'Morgan', 'Peterson', 'Cooper', 'Reed', 'Bailey', 'Bell', 'Gomez', 'Kelly', 'Howard', 'Ward', 'Cox', 'Diaz', 'Richardson', 'Wood', 'Watson', 'Brooks', 'Bennett', 'Gray', 'James', 'Reyes', 'Cruz', 'Hughes', 'Price', 'Myers', 'Long', 'Foster', 'Sanders', 'Ross', 'Morales', 'Powell', 'Sullivan', 'Russell', 'Ortiz', 'Jenkins', 'Gutierrez', 'Perry', 'Butler', 'Barnes', 'Fisher', 'Henderson', 'Coleman', 'Simmons', 'Patterson', 'Jordan', 'Reynolds', 'Hamilton', 'Graham', 'Kim', 'Gonzales', 'Alexander', 'Ramos', 'Wallace', 'Griffin', 'West', 'Cole', 'Hayes', 'Chavez', 'Gibson', 'Bryant', 'Ellis', 'Stevens', 'Murray', 'Ford', 'Marshall', 'Owens', 'Mcdonald', 'Harrison', 'Ruiz', 'Kennedy', 'Wells', 'Alvarez', 'Woods', 'Mendoza', 'Castillo', 'Olson', 'Webb', 'Washington', 'Tucker', 'Freeman', 'Burns', 'Henry', 'Vasquez', 'Snyder', 'Simpson', 'Crawford', 'Jimenez', 'Porter', 'Mason', 'Shaw', 'Gordon', 'Wagner', 'Hunter', 'Romero', 'Hicks', 'Dixon', 'Hunt', 'Palmer', 'Robertson', 'Black', 'Holmes', 'Stone', 'Meyer', 'Boyd', 'Mills', 'Warren', 'Fox', 'Rose', 'Rice', 'Moreno', 'Schmidt', 'Patel']
first_names = ['Michael', 'James', 'John', 'Robert', 'David', 'William', 'Mary', 'Christopher', 'Joseph', 'Richard', 'Daniel', 'Thomas', 'Matthew', 'Jennifer', 'Charles', 'Anthony', 'Patricia', 'Linda', 'Mark', 'Elizabeth', 'Joshua', 'Steven', 'Andrew', 'Kevin', 'Brian', 'Barbara', 'Jessica', 'Jason', 'Susan', 'Timothy', 'Paul', 'Kenneth', 'Lisa', 'Ryan', 'Sarah', 'Karen', 'Jeffrey', 'Donald', 'Ashley', 'Eric', 'Jacob', 'Nicholas', 'Jonathan', 'Ronald', 'Michelle', 'Kimberly', 'Nancy', 'Justin', 'Sandra', 'Amanda', 'Brandon', 'Stephanie', 'Emily', 'Melissa', 'Gary', 'Edward', 'Stephen', 'Scott', 'George', 'Donna', 'Jose', 'Rebecca', 'Deborah', 'Laura', 'Cynthia', 'Carol', 'Amy', 'Margaret', 'Gregory', 'Sharon', 'Larry', 'Angela', 'Maria', 'Alexander', 'Benjamin', 'Nicole', 'Kathleen', 'Patrick', 'Samantha', 'Tyler', 'Samuel', 'Betty', 'Brenda', 'Pamela', 'Aaron', 'Kelly', 'Heather', 'Rachel', 'Adam', 'Christine', 'Zachary', 'Debra', 'Katherine', 'Dennis', 'Nathan', 'Christina', 'Julie', 'Jordan', 'Kyle', 'Anna']
majors = ['CPSC', 'CPEN', 'COMP']
classifications = ["U1, U2, U3, U4"]
uins = ['594697295', '515982188', '630763517', '319959064', '500316026', '601621761', '649963639', '670125546', '200032062', '766987795', '144295831', '616467901', '750509896', '262304441', '206879215', '210497458', '472031567', '591778188', '763173065', '492027191', '386582631', '910439525', '512224855', '540977400', '966563749', '360326388', '247802507', '708115672', '694830635', '618011011', '995855349', '396921854', '949082141', '476701076', '271753614', '155847855', '183322154', '218659074', '267762246', '862824860', '878581810', '758977541', '899147743', '997612638', '386225014', '333675729', '159071042', '207511690', '729157310', '477441795', '500019044', '916342197', '811143070', '983245212', '878506682', '703371728', '420566623', '833690004', '470465735', '235836451', '921344845', '983634186', '901856025', '834924081', '133737729', '413153544', '452271426', '753506737', '630180552', '132323066', '189420995', '714068752', '553025880', '830168787', '153333956', '130638878', '472876477', '350977565', '745023554', '827461784', '884373090', '321006488', '377291578', '885330056', '127691269', '908352168', '217268319', '963030091', '912309989', '694642134', '752497981', '105711882', '625444434', '990974880', '768084471', '857311149', '262523397', '108466177', '420746051', '777532198', '752512117', '828343444', '779687227', '326673396', '298842899', '159753347', '450382074', '922932017', '231050182', '254651508', '860286945', '772907321', '910959432', '412192627', '790848510', '741447463', '451048370', '252948785', '623022781', '807580383', '347299879', '470213320', '311904233', '201312755', '382268896', '316655643', '267917730', '778245130', '404058116', '455743462', '170260695', '981988223', '396069279', '381460247', '173923378', '105891217', '826975313', '527151646', '548437161', '314540455', '258366297', '280190680', '663267386', '114678534', '143941536', '577803642', '820151953', '653562379', '310974137', '617914727', '429405254', '739969398', '222321680', '876722329', '815885588', '383934129', '490874435', '117781827', '321130005', '265463050', '935535826', '585776288', '689634121', '130464947', '291141077', '365517638', '247390549', '623560356', '163629852', '239899204', '163627913', '527721133', '310963124', '368636054', '901850816', '650400241', '640076990', '540602994', '796478810', '941440016', '592176990', '387847804', '543427648', '263746495', '710375367', '749675660', '469062913', '596319115', '659594914', '686804750', '978534379', '482649604', '934061144', '642480104', '484108790', '437700103', '714115386', '852697619', '855548497', '682234270']

for uin in uins do
    first_name = first_names.sample
    last_name = last_names.sample
    email = first_name + "." + last_name + "@tamu.edu"
    Student.create(
        firstname:first_name,
        lastname:last_name,
        uin: uin,
        email: email,
        classification: classifications.sample,
        major: majors.sample,
        teacher: 'team_cluck_admin@gmail.com',
        last_practice_at: Time.now,
        curr_practice_interval: 120

    )
end

for student in Student.all do 
    StudentCourse.create(course_id: Course.all.sample.id, student_id: student.id)
end


User.create(email: 'yourdummycluck@gmail.com', password: 'abc_123!')
User.where(confirmed_at: nil).update_all(confirmed_at: Time.now)

