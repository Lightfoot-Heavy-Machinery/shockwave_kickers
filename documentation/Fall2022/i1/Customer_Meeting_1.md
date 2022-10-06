# Shockwave Kickers
**Iteration 1 – 09/30/2022**

## Flow
- Showed frontend
- 


## Notes
- Classification doesn't matter as much
- Including major could be nice
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
- Be mindful of Heroku 
- He wants to upload a CSV and a folder
    - Folder named "BWXKPHOTO_files"