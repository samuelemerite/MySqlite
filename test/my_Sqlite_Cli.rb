require 'readline'
require_relative 'my_Sqlite_Request'

# gestion de la récupération des éléments entré par l'utilisateur

def read_line_v
    vline = Readline.readline('my_sqlite> ', true)
    return vline
end

# Conforms the arr to the SET methods format.
def convert_to_hash(arr)
    result = Hash.new
    i = 0
    while i < arr.length 
        left, right = arr[i].split(" = ")
        result[left] = right.delete_prefix("'").chomp("'")
        i += 1
    end
    return result
end 

###
 # afiiche les résultats de la commande Select
def affichage_pour_select(result)
    if !result
        return
    end
    if result.length == 0
        puts "No result."
    else
        header = result.first.keys.join('|') 
        puts header
        puts "-" * header.length
        result.each do | line |
        puts line.values.join('|')
        end
    end
end
  
#####


# appeler les méthodes correspondantes
def command_appel(cmd, args, request)
    case cmd
    when "from"
      if args.length != 1
        puts "Example: FROM nba_player.csv"
        return
      else
        request.from(*args)
      end
    when "select"
      if args != nil   #|| args[0].include?(",")
        puts "Example: SELECT name, age"
        return
      else
        p args
        #request.select(args[1])
        p args[1]
      end
    when "insert"
      args = args[0].split(" ").drop(1) # Removes "INTO" .
   
      if args[1] != nil
        if args[1].include?(")") == false
          puts "Example: (name,age)"
        end
        args[1] = args[1].delete_prefix("(").chomp(")").split(",")
      end
      request.insert(*args)
    when "values"
      if args.length < 1
      puts "Provide data to insert. Example: (Bob, 30)"
      else
        # Conforms values for @data.
        args = args.join(" ").delete_prefix("(").chomp(")")
        args = args.split(",").map(&:strip)
        if args[0].include?(",")
          puts "Example: (Bob, 30)"
        end
        request.values(args)
      end
    when "delete"
      if args.length != 0
        puts "Example: DELETE FROM nba_player.csv. Don't forget to use WHERE."
      else
        request.delete 
      end
    when "where"
      if args.length != 3
        puts "Example: WHERE age = '20'"
      else
        value = args[2].delete_prefix("'").chomp("'")
        request.where(args[0], value)
      end
    when "order"
      if args.length != 2
        puts "Example: ORDER age ASC"
      else
        col_name = args[0]
        sort_type = args[1].downcase.to_sym
        request.order(sort_type, col_name)
      end
    when "join"
      if args.length != 3
        puts "Example: JOIN table ON col_a=col_b"
      elsif args[1].upcase != "ON"
        puts "Provide ON statement. Example: JOIN table ON col_a=col_b"
        return
      else
        table = args[0]
        col_a, col_b = args[2].split("=")
        request.join(col_a, table, col_b)
      end
    when "update"
      if args.length != 1
        puts "Example: UPDATE db.csv"
      else
        request.update(*args)
      end
    when "set"
      if args.length < 1
        puts "Example: SET name=BOB. Use WHERE - otherwise WATCH OUT."
      else
        request.set(convert_to_hash(args)) 
      end
    else
      puts "Please follow the syntax."
      puts "If you want to quit - type quit."
    end
end

####### fonction d'execution

def execute_request(sql)
    # Liste des commandes SQL valides
    valid_commands = ["SELECT", "FROM", "JOIN", "WHERE", "ORDER", "INSERT", "VALUES", "UPDATE", "SET", "DELETE"]
  
    # Initialisation des variables
    command = nil
    args = Array.new
    request = MySqliteRequest.new
  
    # Séparation de la commande SQL en mots
    split_command = sql.split(" ")
    #p split_command
  
    # Boucle sur chaque mot dans la commande SQL
    0.upto split_command.length - 1 do |arg|
      # Vérification si le mot est une commande SQL valide
      if valid_commands.include?(split_command[arg].upcase())
        # Si une commande est déjà en cours, la traiter avec ses arguments
        if (command != nil)
          if command != "join"
            args = args.join(" ").split(", ")
          end
          
          command_appel(command, args, request)
          command = nil
          args = []
        end
  
        # Met à jour la commande en cours
        command = split_command[arg].downcase()
      else
        # Ajoute les arguments aux commandes
        args << split_command[arg]
      end
    end
  
    # Correction du dernier argument si nécessaire (suppression du point-virgule)
    if args[-1].end_with?(";")
      args[-1] = args[-1].chomp(";")
    end
  
    # Appelle la méthode appropriée avec la commande et les arguments traités
    command_appel(command, args, request)
  
    # Exécute la requête et affiche le résultat pour les requêtes SELECT
    result = request.run
    affichage_pour_select(result)
end
  
 

  
def main
    puts "MySQLite version 1.0 2023"
    while command = read_line_v
      if command == 'quit'
        break
      elsif command == ''
        next
      else
        execute_request(command)
      end
    end
end
  
  main()