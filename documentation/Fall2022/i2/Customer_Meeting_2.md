# Shockwave Kickers
**Iteration 2 – 10/21/2022**

## Flow
- Showed frontend, various pages were close to what we decided on figma
- Demoed authentication and mail confirmations as well in the heroku app


## Notes
- Classification doesn't matter as much
- Figuring out how to scrap semester, course name and section
    - Web scraper from public website
    - Use SSO credentials
    - Decision is to use filename to parse these and put the other ideas as backburners
- Professor requested to implemented SSO, so created a story
- Image upload
    - Does not want to upload 1 by 1
    - Howdy has a image roster
        - Could write script to save the image roster
        - Saves it as a full webpage, which puts the images in a directory
        - Images get saved in convention like bmxphoto, bmxphoto(1), ..., bmxphoto(n)
        - They are in alphabetical order, so we can match to roster as long as we pull rosters and photos at the same time
            - Rename files with the UINs
    - <b>Error Throwing</b>
        - If only uploading one file (rather than both csv and img)
        - If numbers/length of files are mismatched
    - Keep newest photo of students
