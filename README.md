# Welcome to My Sqlite
 app to do search in data base

## Task
the challenge is to reproduce mysqlite,the most striking difficulty was the functions join, order, where and delete

## Description
I separated the work into several functions on one side the functions that call them on the other the one that executes them,we first take the request, we split it to recover the part to be executed then we use a function for formatting

## Installation
just write ruby my_sqlite_cli.rb and run the command in the terminal
## Usage
you could test the functions of request file, just run the file my_sqlite_request with these lines:
request = MySqliteRequest.new
request = request.from('nba_player_data.csv')
request = request.select('college')
request = request.join('college','nba_players.csv','collage')
request = request.order('desc','name')
request.run

request = MySqliteRequest.new
request = request.from('nba_player_data.csv')
request = request.select('*')
request = request.where('college', 'University of California')
request = request.where('year_start', '1997')
request.run

request = MySqliteRequest.new
request = request.insert('nba_player_data.csv')
request = request.values('name' => 'Samuel Emerite Abdelnaby', 'year_start' => '2021', 'year_end' => '2023', 'position' => 'F-C', 'height' => '6-10', 'weight' => '240', 'birth_date' => "June 24, 1968", 'college' => 'Duke University')
request.run


request = MySqliteRequest.new
request = request.update('nba_player_data.csv')
request = request.values('name' => 'Alaa Renamed')
request = request.where('name', 'Alaa Abdelnaby')
request.run

request = MySqliteRequest.new
request = request.update('nba_player_data.csv')
request = request.values('college' => 'Duke Renamed')
request = request.where('college', 'Duke University')
request.run

request = MySqliteRequest.new
request = request.delete()
request = request.from('nba_player_data.csv')
request = request.where('name', 'Minkada Ekani Samuel Emerite')
request.run

write you request following the exemple

SELECT name,college FROM  nba_player_data.csv WHERE name = 'Matt Zunic';
SELECT * FROM nba_player_data.csv WHERE year_start = '1991';
"UPDATE nba_player_data.csv SET college = 'University of California' WHERE college = 'George Washington University';"
"SELECT * FROM students.csv;"
"INSERT INTO students.csv VALUES (John, john@johndoe.com, A, https://blog.johndoe.com);"
"INSERT nba_players.csv VALUES (4000, Minkada, 180, 87,,);"
"SELECT name,college,year_start FROM nba_player_data.csv WHERE name = 'Kareem Abdul-Jabbar';"
"INSERT INTO nba_player_data.csv VALUES ('RaHuel Rite Abdelnaby', '2021', '2023', 'F-C', '6-10','240','June 24, 1968', 'Duke University');"
### The Core Team


<span><i>Made at <a href='https://qwasar.io'>Qwasar SV -- Software Engineering School</a></i></span>
<span><img alt='Qwasar SV -- Software Engineering School's Logo' src='https://storage.googleapis.com/qwasar-public/qwasar-logo_50x50.png' width='20px' /></span>
