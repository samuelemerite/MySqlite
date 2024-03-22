require 'csv'
require 'readline'
require_relative "./my_sqlite_request"
require './function.rb'

class My_sqlite_cli
    def initialize
        @argument = 0
        @db_name = ""
        @verify = []
    end

    def readSelect(sentence)
        answer = []
        request = MySqliteRequest.new
        if sentence != "" and sentence.include?(";")
            if sentence.downcase.include?("select")
                result = sentence.split("SELECT").join()
                if result.downcase.include?("from")
                    result =  result.split("FROM")and table_name = result[0].strip
                    if result[1].downcase.include?("where")
                        result = result[1].split("WHERE")
                        database_name = result[0].strip and condition = result[1].scan(/(\w+)\s*=\s*'([^']+)';/).map { |match| match[0, 2] }.flatten
                        @argument = table_name.strip.split(",")
                        return answer.push(request.from(database_name).select(table_name.strip).where(*condition).run)
                    else 
                        table_name = result[0] and database_name = result[1].split(";")
                        database_name = database_name[0].strip
                        @argument = table_name.strip.split(",")
                        return answer.push(request.from(database_name).select(table_name.strip).run)
                    end
                end
            end
        else
            puts "give a correct command\nExample:\n SELECT table_name FROM database_name WHERE condition;\ndon't forget ;"
        end
    end

    def readInsert(sentence)
        request = MySqliteRequest.new
        if sentence != "" and sentence.include?(";")
            if sentence.downcase.include?("insert")
                result = sentence.split("INSERT INTO").join()
                if result.downcase.include?("values")
                    result =  result.split("VALUES")and database_name = result[0].strip
                    values = result[1].split(";")        
                    val = values[0].strip.gsub(/[()'"]/,'')
                    headers = []
                    if File.exist?(database_name)
                        CSV.foreach(database_name, headers: true) do |row|
                            headers = row.headers
                            break
                        end
                    else 
                        p "this file doesn't exist"
                    end
                    hash_data = headers.zip(val.split(",")).to_h 
                    @verify = hash_data
                    @db_name = database_name
                    request.insert(database_name).values(hash_data).run
                    p "it is okay"
                end
            end
        else
            puts "give a correct command\nExample:\n INSERT INTO students.csv VALUES ('Samuel Emerite Abdelnaby', '2021', '2023', 'F-C', '6-10', '240', 'June 24, 1968', 'Duke University');\ndon't forget ;"
        end
    end

    def readUpdate(sentence)
        request = MySqliteRequest.new
        if sentence != "" and sentence.include?(";")
            if sentence.downcase.include?("update")
                result = sentence.split("UPDATE").join()
                if result.downcase.include?("set")
                    result =  result.split("SET")and database_name = result[0].strip
                    if result[1].downcase.include?("where")
                        data = []
                        result[1].split("WHERE").map do |elt|
                            data.push(elt.strip)
                        end
                        data_up_to = data[0] and condition = data[1]
                        condition = condition.split(";").join()
                        data_up_to = data_up_to.scan(/(\w+)\s*=\s*'([^']+)'/).to_h
                        cond = []
                        condition.split("=").map do |elt|
                            cond.push(elt.strip.delete("'"))
                        end
                        request.update(database_name).values(data_up_to).where(cond[0],cond[1]).run
                    end
                end
            end
        else
            puts "give a correct command\nExample:\n UPDATE nba_player_data.csv SET college = 'University of California' WHERE college = 'George Washington University';\ndon't forget ;"
        end
    end

    def readDelete(sentence)
        request = MySqliteRequest.new
        if sentence != "" and sentence.include?(";")
            if sentence.downcase.include?("delete")
                result = sentence.split("DELETE").join()
                if result.downcase.include?("from")
                    result =  result.split("FROM")
                    if result[1].downcase.include?("where")
                        data = []
                        
                        result[1].split("WHERE").map do |elt|
                            data.push(elt.strip)
                        end
                        database_name = data[0] and condition = data[1]
                        condition = condition.split(";").join()
                        cond = []
                        condition.split("=").map do |elt|
                            cond.push(elt.strip.delete("'"))
                        end
                        request.delete().from(database_name).where(*cond).run            
                    end
                end
            end
        else
            puts "give a correct command\nExample:\n DELETE FROM nba_player_data.csv WHERE name = 'Matt Zunic';\ndon't forget ;"
        end
    end

    def organize(result)
        screen = []
        result[0].each_slice(@argument.length) do |group|
            screen.push(group)
        end
        if screen.empty? 
            puts "No answer found"
        else
            screen.map do |elt|
                p elt
            end
        end
    end

    def verify(sentence)
        table = []
        table = read_on_file(@db_name)

    end

    def useFunction(sentence)
        if sentence.downcase.include?("select")
            organize(readSelect(sentence))
        end
        
        if sentence.downcase.include?("insert")
            readInsert(sentence) 
            p "it is ok"
            #verify(@d)
        end
        
        if sentence.downcase.include?("update")
            readUpdate(sentence)
            p "it is ok"
            #create a function that will review if modification have been done
        end

        if sentence.downcase.include?("delete")
            readDelete(sentence)
            p "it is ok"
            #create a function that will review if modification have been done

        end
        
    end

    def run
        history = []
        while (line = Readline.readline("MySQLite version 1.0\nPLease use '' and ; in your command like\n\tSELECT * FROM nba_player_data.csv WHERE year_start = '1991';\nor\n\tSELECT name,college FROM  nba_player_data.csv WHERE name = 'Matt Zunic';\n\texit with the command 'exit'\nMySQLite version 1.0\n$>", true))
            case line.chomp
            when 'exit'
              break
            when ''
              next
            else
              Readline::HISTORY.push(line)
              history.push(line)
              useFunction(line)
            end
          end
    end

    
end

cli = My_sqlite_cli.new
#cli.readSelect("SELECT name,college,year_start from nba_player_data.csv where name = 'Kareem Abdul-Jabbar';");
#p cli.readSelect("SELECT * from nba_player_data.csv ;");
#cli.readInsert("INSERT INTO nba_player_data.csv VALUES ('RaHuel Rite Abdelnaby', '2021', '2023', 'F-C', '6-10','240','June 24, 1968', 'Duke University');")
#cli.readUpdate("UPDATE nba_player_data.csv SET college = 'University of California' WHERE college = 'George Washington University';")
#cli.readDelete("DELETE FROM nba_player_data.csv WHERE name = 'Matt Zunic';")
#cli.useFunction("SELECT name,college FROM nba_player_data.csv WHERE name = 'Matt Zunic';");
#cli.useFunction("INSERT INTO nba_player_data.csv VALUES ('RaHuel Rite Abdelnaby', '2021', '2023', 'F-C', '6-10','240','June 24, 1968', 'Duke University');")

cli.run