require 'csv'
#require 'sqlite3'
require './function.rb'
class MySqliteRequest

    def init
        @table_name = nil
        @column_name = []
        @request = ''
        @where = {}
        @join = {}
        @on = {}
        @data
        @set
    end

    def from(table_name)
        @table_name = table_name
        return self
    end

    def select(column_name)
        @request = 'select'
        if column_name.length == 1 or column_name == '*'
            @column_name = column_name
        else
            @column_name = column_name.split(",") 
        end
        return self
    end
    
    def where(column_name,criteria)
        @where = {column_name:column_name,criteria:criteria}
        return self
    end

    def join(column_on_db_a, filename_db_b, column_on_db_b)
        if column_on_db_b.length == 1
            column_on_db_b = column_on_db_b
        else
            column_on_db_b = column_on_db_b.split(',')
        end
        @join =  {column_on_db_a:column_on_db_a,filename_db_b:filename_db_b,column_on_db_b:column_on_db_b}
        return self
    end

    def order(order, column_name)
        @order = {order:order,column_name:column_name}
        return self
    end

    def insert(table_name)
        @request = 'insert'
        @table_name = table_name
        return self
    end

    def values(data)
        @data = data.to_hash
        return self
    end

    def update(table_name)
        @request = 'update'
        @table_name = table_name
        return self
    end

    def set(data)
        @set =data
        return self
    end

    def delete
        @request = 'delete'
        return self
    end

    def run
        #init the table who content the current data
        table = []

        #init the variable which will content the final result
        result = nil

        #verify if @table_name content something and extract data
        if @table_name == nil 
            puts "enter a correct data base"
        else
            table = read_on_file(@table_name)
            #puts table
        end

        if @request == 'select'
            table = select_op(@column_name,table)

            if @where != nil
                data = []
                data = read_on_file(@table_name)
                table = where_operation({@where[:column_name]=>@where[:criteria]},data)
                table = select_op(@column_name,table)
            end
            
            if @join != nil 
                table_b = select_op(@join[:column_on_db_b],read_on_file(@join[:filename_db_b]))
                table_a = table#select all the line that verify the criteria_a
                table = join_operation(@join[:column_on_db_a],@join[:column_on_db_b],table_a,table_b)
            end
            
            if @order != nil
                table = order_operation(table,@order[:order],@order[:column_name])
            end

        elsif @request == 'insert'
            if @table_name != nil
                if @data != nil
                    table = modify_file(@table_name,@data)
                end
            end
        elsif @request == 'update'
            if @table_name != nil and @data != nil and @where != nil
                table = update_operation(@table_name,@data,@where)
            else
                puts "error fill value and where"
            end
        elsif @request == 'delete'
            if @table_name != nil and @where != nil
                delete_operation(@table_name,@where)
            else
                puts "error fill the table name  and where's informations"
            end
        end
        return table
    end
end
#request = MySqliteRequest.new
#request = request.from('nba_player_data.csv')
#request = request.select('college')
#request = request.join('college','nba_players.csv','collage')
#request = request.order('desc','name')
#request.run

#request = MySqliteRequest.new
#request = request.from('nba_player_data.csv')
#request = request.select('*')
# request = request.where('college', 'University of California')
#request = request.where('year_start', '1997')
#request.run

# request = MySqliteRequest.new
# request = request.insert('nba_player_data.csv')
# request = request.values('name' => 'Samuel Emerite Abdelnaby', 'year_start' => '2021', 'year_end' => '2023', 'position' => 'F-C', 'height' => '6-10', 'weight' => '240', 'birth_date' => "June 24, 1968", 'college' => 'Duke University')
# request.run


# request = MySqliteRequest.new
# request = request.update('nba_player_data.csv')
# request = request.values('name' => 'Alaa Renamed')
# request = request.where('name', 'Alaa Abdelnaby')
# request.run

# request = MySqliteRequest.new
# request = request.update('nba_player_data.csv')
# request = request.values('college' => 'Duke Renamed')
# request = request.where('college', 'Duke University')
# request.run

# request = MySqliteRequest.new
# request = request.delete()
# request = request.from('nba_player_data.csv')
# request = request.where('name', 'Minkada Ekani Samuel Emerite')
# request.run

# request =MySqliteRequest.new
# p request.from('nba_player_data.csv').select('name,college').run