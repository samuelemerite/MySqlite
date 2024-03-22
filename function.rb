require 'csv'

def read_on_file(file_name)
    data = []
    if file_name != nil 
        data = CSV.open(file_name, headers: true).map(&:to_hash)
    end
    return data
end

def select_op(column_name,data)
    table = []
    if column_name.length == 1 and column_name == '*'
        return data
    else
        data.map do |line|
            column_name.map do |key|
                line.map do |elt,value|
                    if key == elt
                        table << {elt=>value}
                    end
                end
            end
        end
        #puts table
        return table    
    end
end


def where_operation(criteria_objet,table)
    data = []
    if criteria_objet != nil
        table.map do |line|
            line.map do |target, value|
                criteria_objet.map do |elt,content|
                    if value == content
                        data << line
                    end
                end
            end
        end
    end
    return data
end


def join_operation(col_a,col_b,table_a,table_b)
    data = []
    table_a.map do |line_a|
        if line_a[col_a] !=nil
            table_b.map do |line_b|
                if line_b[col_b[0]] !=nil
                    if line_a[col_a] == line_b[col_b[0]] 
                        data << {[col_a,col_b[0]]=>line_a[col_a]}
                    end
                end
            end
        end
    end
    return data
end

def order_operation(table,order,column_name)
    data =[]
    if order == 'asc'
        table.map do  |line|
            data << line[column_name]
            data = data.sort
        end
       # puts data
    elsif order == 'desc'
        table.map do  |line|
            if line[column_name] != nil
                data << line[column_name]
            end
            data = data.sort.reverse
        end
    end
    table = []
    data.map do |elt|
        table << {column_name=>elt}
    end
    return table
end


def modify_file(table_name,data)
    len = read_on_file(table_name).length
    table = read_on_file(table_name)
    table[len] = data
    CSV.open(table_name,"w", :headers=> true) do |csv|
        csv << table[0].keys
        table.each do |line|
            csv << CSV::Row.new(line.keys,line.values)
        end
    end
end

def update_operation(table_name,data,where)
    table = read_on_file(table_name)
    where_n = []
    where.map do |elt|
        where_n.push(elt[1])
    end
    table.map do |line|
        line.map  do |componant|
            componant.map do |content|
                if content == where_n[1]
                    line[componant[0]] = data.values[0]
                end
            end
        end
    end
    CSV.open(table_name,"w",:headers=>true) do |csv|
        csv << table[0].keys
        table.each do |line|
            csv <<  CSV::Row.new(line.keys,line.values)
        end
    end
end

def delete_operation(table_name,where)
    table = read_on_file(table_name)
    where_n = []
    where.map do |elt|
        where_n.push(elt[1])
    end
    index = 0
    table.map do |line|
        index = index +1
        line.map  do |componant|
            componant.map do |content|
                if content == where_n[1]
                    table.delete(line)
                end
            end
        end
    end
    CSV.open(table_name,"w",:headers=>true) do |csv|
        csv << table[0].keys
        table.each do |line|
            csv <<  CSV::Row.new(line.keys,line.values)
        end
    end
    
end

# table = read_on_file('nba_player_data.csv')
# s=select_op(["*"],table)
# p s
#where_operation({"year_start"=>"1991"},table)
#order_operation(table,'desc','name')
#table = select_op(['name','year_start'],'table')