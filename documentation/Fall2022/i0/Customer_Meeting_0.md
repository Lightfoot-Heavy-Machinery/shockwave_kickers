# Shockwave Kickers
**Iteration 0 – 09/23/2022**

SCRUM Master: Jacob Kelly

Product Owner: Rahul Shah

## Topics:
1. Introductions
2. Needs review
3. Review wireframe

## Key Concepts:


## Notes:
- He'll be uploading CSV
  - Rosters 25-100 students
  - CSV has a bunch of junk in it
      - Grades, emails, etc
      - Grades don't exist at start of semester
    - Can also export image roster
- By end of semester he usually gets ~70% of people's names
  - Wants to get as close to 100% as possible
  - He'll get emais re: reference letters
    - Difficult to place students because of number of students, sections, semesters, etc.
- Potentially need to include ability to list and/or recognize nicknames? (Samuel v Sam, etc.)

- What he wants to do
  - Uploads CSV of roster
  - Highlights students he has had before
  - Uploads the image roster
  - Wants to search for student
    - Be able to refine search by semster, course, sections, etc.


- Potentially include netIDs? Some students include this when asking for ref letters  

- FERPA Notes: We can get data from our 606 class for test data

- When downloading data, it downloads slightly different based on OS
  - We may need to run a conversion script


- For image storage, we can use S3Bucket

- Lightfoot says it alright with it being a local app if online storage isn't plausible

- Images and namegame really only <i>needed</i> for current semester

- <b>Must</b> be secure

- CSV Uploads/Updates (possibility)
  - Day 1 will be initial, no grades
  - Day 12, after add/drop, may or may not have grades
  - End of semester (may lose some students to Q drops)

- CSV format and headers are the same at any point in time, for any course

- For students that disappear from the roster, assign tags

- We can use UINs as primary key

- Include student grades to prevent him having to return to Howdy

- Flag or display repeats on uploads
  - <b>IMPORTANT: </b> add page to display current repeat students

- For multiple users, make it multiple instances, rather than multiple accounts

- Use authentication, most likely using Tamu sign in, Duo

- ### MVP FIRST ITERATIONS: ### 
  - Prioritize upload, sort and search features
  - As well as quiz for current semesters

- Use placeholders for all missing values, including images

- <b>Future features</b>
  - Report generation
    - Display repeats
    - Most frequent students

- Dr. Lightfoot Office Hours
  - 11-12 Mondays