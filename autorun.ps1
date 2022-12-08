#run in admin mode by default
$shell = New-Object -ComObject Shell.Application -ErrorAction SilentlyContinue
#CHANGE FILE DIRECTORY TO YOUR OWN PATH
$shell.ShellExecute("powershell.exe", "-ExecutionPolicy Bypass -File C:\Users\Public\Documents\autorun.ps1", "", "runas", 1)

#run ruby environment
$env:Path = "C:\Ruby22-x64\bin;" + $env:Path
& bundle install

#PUT YOUR CREDS IN!
#$user = "postgres"
#$upassword = ""
#$email = ""
#$epassword = ""

#database is current working directory + /config/database.yml ASSUMING YOU ARE IN THE REPO
'
$database = Get-Location
$database = $database + "\config\database.yml"
$database = Get-Content $database
$database = $database -replace "username:", "username: $user"
$database = $database -replace "password:", "password: $upassword"
'

#set username and password in config/environments/producton.rb
'
$production = Get-Location
$production = $production + "\config\environments\production.rb"
$production = Get-Content $production
$production = $production -replace "username:", "username: $email"
$production = $production -replace "password:", "password: $epassword"
'

#open pgadmin4 application without prompting for admin
$shell = New-Object -ComObject Shell.Application
$shell.ShellExecute("C:\Program Files\PostgreSQL\15\pgAdmin 4\bin\pgAdmin4.exe", "", "", "runas", 1)

#setup rails environment
& rake db:create
& rake db:migrate
& rake db:seed
& bundle exec rake assets:precompile

#open firefox browser. Change to your browser of choice!
$shell.ShellExecute("C:\Program Files\Mozilla Firefox\firefox.exe", "http://127.0.0.1:3000", "", "runas", 1)

& rails s -e test

#hit refresh afterwards.