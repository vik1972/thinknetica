require_relative "maker"
require_relative "instances_counter"
require_relative "train"
require_relative "wagon"
require_relative "station"
require_relative "route"
require_relative "cargo_train"
require_relative "passenger_train"
require_relative "cargo_wagon"
require_relative "passenger_wagon"


class Controller
 
  attr_accessor :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end
=begin
  def seed
    trains << CargoTrain.new("111")
    trains << CargoTrain.new("222")
    trains << CargoTrain.new("333")
    trains << PassengerTrain.new("011")
    trains << PassengerTrain.new("022")
    trains << PassengerTrain.new("033")
    puts "Trains:"
    trains.each {|x| puts "#{x.number}, #{x.type}, #{x.wagons}"}
    routes << Route.new("Калининград", "Москва")
    routes << Route.new("Калининград", "Санк-Петеребург")
    routes << Route.new("Новосибирск", "Москва")
    routes.each {|x| puts "#{x.stations.first} - #{x.stations.last}"}
    st = Station.new("Калининград")
    stations << st
    st = Station.new("Москва")
    stations << st
    st = Station.new("Санк-Петеребург")
    stations << st
    st = Station.new("Новосибирск")
    stations << st
    st = Station.new("Волгоград")
    stations << st
    st = Station.new("Саратов")
    stations << st
    st = Station.new("Витебск")
    stations << st
    st = Station.new("Вильнус")
    stations << st
    st = Station.new("В. Новгород")
    stations << st
    st = Station.new("Черняховск")
    stations << st
    puts "Станции:"
    stations.each_with_index {|x, i| puts "#{i+1}. #{x.name}"}
    puts "All stations #{stations.size}"
  end
=end

  def print_stations 
    if stations.empty?
      puts "Станций нет"
    else
      puts "Станции:"
      stations.each_with_index { |x, i| puts "#{i+1}. #{x.name}" }
    end
  end

  def print_trains 
    puts "Поезда"
    trains.each_with_index { |x, i| puts "#{i+1}. #{x.number}" }
  end

  def print_routes 
    puts "Маршруты"
    routes.each_with_index { |x, i| puts "#{i+1}. #{x.stations.first} - #{x.stations.last}" }
  end

  def new_station
    attempt = 0
    begin
      puts "Введите название станции"
      name = gets.chomp
      stations.each do |station|
        if station.name == name
          puts "Станция с таким названием уже есть"
          raise RuntimeError
        end
      end
    rescue
      attempt += 1
      puts "Попытайтесь еще раз."
      retry if attempt < 2
    end
    stations.push(Station.new(name))
  end

  def new_train
    attempt = 0
    begin
      puts "Введите номер поезда" 
      attempt = 0
      name = gets.chomp.to_s
      puts "Укажите необходимый тип поезда ('грузовой' или 'пассажирский')"
      type = gets.chomp.strip
      puts "Укажите количество вагонов"
      count = gets.chomp.to_i
      if type == "грузовой"
        train = CargoTrain.new(name)  
        for i in (1.. count)
          wagon = CargoWagon.new(i)
          train.push_wagon(wagon)
        end
        puts "Поезд №#{name} создан."
        trains.push(train)
      elsif type == "пассажирский"
        train = PassengerTrain.new(name) 
        for i in (1.. count)
          wagon = PassengerWagon.new(i)
          train.push_wagon(wagon)
        end
        puts "Поезд №#{name} создан."
        trains.push(train)
      else
          puts "Неверный тип вагона"
          raise 
      end
    rescue RuntimeError
      attempt +=1 
      puts "Попытайтесь еще раз."
      retry if attempt < 2
    end
  end

  def add_train_to_station(train)
    if train.route.nil?
      puts "У поезда нет маршрута"
    elsif train.route.size <= train.current_location
      puts "Это конечная станция маршрута"
    else
      number_station = train.current_location
      name_station = train.route[number_station]
      stations.each do |station| 
        if station.name == name_station 
          station.take_train(train)
        end
      end
    end
  end

  def del_train_to_station(train)
    if train.route.nil?
      puts "У поезда нет маршрута"
    else
      number_station = train.current_location
      name_station = train.route[number_station]
      stations.each do |station| 
        if station.name == name_station 
          station.send_train(train)
        end
      end
    end
  end

  def moving_train
    loop do
      if trains.empty? || routes.empty?
        puts "Нет ни одиного поезда и ни одного маршрута"
      else
        puts "Введите порядковый номер поезда или 0 для выхода"
        print_trains
        train = gets.chomp.to_i
        if train < 1 || train >trains.size 
          puts "Поезда с таким номером нет"
          break
        else
          puts "Выберете направление (1 - одна станция вперед, 0 - прекратить движение, и -1 - станция назад)"
          direction = gets.chomp.to_i
          if direction == 1
            del_train_to_station(trains[train-1])
            trains[train-1].forward
            add_train_to_station(trains[train-1])
          elsif direction == -1
            del_train_to_station(trains[train-1])
            trains[train-1].back
            add_train_to_station(trains[train-1])
          else
            break
          end
        end
      end
    end
  end

  def new_route
    begin
      attempt = 0
      if stations.length >= 2
        print_stations
        puts "Введите 0, если надо ввести новую станцию или 1 чтобы создать маршрут из имеющихся станций"
        comand = gets.chomp.to_i
        if comand == 0 
          new_station
        end
        print_stations
        puts "Введите порядковый номер первой станции маршрута"
        first = gets.chomp.to_i
        puts "Введите порядковый номер последней станции маршрута"
        last = gets.chomp.to_i
        if first > 0 &&  last <= stations.size
          routes << Route.new(stations[first-1].name, stations[last-1].name)
          puts "Ноый маршрут: #{stations[first-1].name} - #{stations[last-1].name}"
        else
           puts "Неверный порядковый номер станции first=#{first} last=#{last} count=#{stations.size}" 
        end
      else
        puts "Недостаточно станций для составления маршрута. Вернитесь в меню и создайте минимум 2 станции"
        raise
      end
    rescue RuntimeError
      attempt +=1 
      puts "Попытайтесь еще раз."
      retry if attempt < 2
    end
  end
   

  def edit_route
    if routes.empty?
      puts "Нет маршрутов для редактирования. Создайте хотя бы один маршрут"
    else
      print_routes
      puts "Введите порядковый номер маршрута"
      route = gets.chomp.to_i
      if route < 1 || route > routes.size
        puts "Маршрут с таким номером отсутствует"
      else
        puts "Если вы хотите удалить станцию из маршрута введите 1, если добавить - 2"
        action = gets.chomp.to_i
        if action == 1
          puts "Введите номер станции"
          routes[route-1].show_route
          pos = gets.chomp.to_i
          if pos >= routes[route-1].stations.size || pos == 1
            puts "Нельзя удалить первую или последнюю станцию маршрута"
          else
            name = routes[route-1].stations[pos-1]
            routes[route-1].delete_station(name) if routes[route-1].stations.include?(name)
          end
        elsif action == 2
          puts "Введите номер станции"
          print_stations
          pos = gets.chomp.to_i
          if pos > 0 && pos <= stations.size
            routes[route-1].add_station(stations[pos - 1].name)
          else
            puts "Станции с таким номером нет"
          end
        end
      end
    end
  end

  def route_controller
    puts "Введите 1 для создания маршрута"
    puts "Введите 2 для редактирования маршрута"
    puts "Введите 0 для возвращения в главное меню"
    chose = gets.chomp
    case chose
    when "1"
      new_route
    when "2"
      edit_route
    else 
      puts "Вы возвращены в главное меню"
    end
  end

  def get_route
    puts "Введите порядковый номер поезда в списке"
    print_trains
    train = gets.chomp.to_i
    puts "Введите порядковый номер маршрута в списке"
    print_routes
    route = gets.chomp.to_i
    if (train < 1 || train > trains.size) || (route < 1 || route > routes.size)
    else
      trains[train-1].get_route(routes[route-1])
      station = routes[route-1].stations.first
      stations.each do |x| 
        if x.name == station && !(x.trains.include?(trains[train-1]))
          x.trains << trains[train-1]
        end
      end
    end
  end

  def add_wagon
    if trains.empty?
      puts "Список поездов пустой. Создайте новый поезд"
    else
      puts "Введите порядковый номер поезда"
      print_trains
      train = gets.chomp.to_i
      if train < 1 || train > trains.size
        raise RuntimeError
      end
      number_wagon = trains[train-1].wagons.size
      if trains[train-1].type == :cargo
        wagon = CargoWagon.new(number_wagon)
      else
        wagon = PassengerWagon.new(number_wagon)
      end
      if (train > 0 && train <= trains.size)
        trains[train-1].push_wagon(wagon)
      end
    end
  end
  
  def del_wagon
    if trains.empty?
      puts "Список поездов пустой. Создайте новый поезд"
    else
      puts "Введите порядковый номер поезда"
      print_trains
      train = gets.chomp.to_i
      if train < 1 || train > trains.size
        raise RuntimeError
      end
      trains[train-1].delete_wagon if (train > 0 && train <= trains.size)
    end
  end

  def print_station_trains(station,type)
    case type
    when "cargo"
      puts "Грузовые поезда станции #{stations[station-1].name}"
      stations[station-1].trains_by(:cargo).each {|train| puts "Поезд № #{train.number}, вагонов: #{train.wagons.size}, текущая станция: #{train.current_location}"}
    when "passenger"
      puts "Пассажирские поезда станции #{stations[station-1].name}"
      stations[station-1].trains_by(:passenger).each {|train| puts "Поезд № #{train.number}, вагонов: #{train.wagons.size}, текущая станция: #{train.current_location}"}
    else
      puts "Все поезда станции #{stations[station-1].name}"
      stations[station - 1].show_trains
    end
  end

  def list_trains
    if trains.empty? || stations.empty?
      puts "Нет станций и поездов"
    else
      puts "Выберите станцию для просмотра всех поездов на ней"
      print_stations
      station = gets.chomp.to_i
       if station < 1 || station > stations.size
         puts "Неверный номер станции"
       else
      puts "Введите all для вывода всех поездов станции"
      puts "Введите cargo для вывода грузовых поездов станции"
      puts "Введите passenger для вывода пассажирских поездов станции"
      chose = gets.chomp.to_str
      print_station_trains(station,chose)
       end
    end
  end

  def show_route
    print_routes
      puts "Введите порядковый номер маршрута"
      route = gets.chomp.to_i
      if route < 1 || route > routes.size
        puts "Маршрут с таким номером отсутствует"
      else
        routes[route-1].show_route
      end
  end
  
  def start
    loop do
      puts " - Для создания станции введите 1"
      puts " - Для создания поезда введите 2"
      puts " - Для работы с маршрутом(создание/редактирование) введите 3"
      puts " - Для назначения маршрута поезду введите 4"
      puts " - Для добавления вагона к поезду введите 5"
      puts " - Для отцепления вагона от поезда введите 6"
      puts " - Для начала перемещения по маршруту нажмите 7"
      puts " - Для начала просмотра списка поездов на станции нажмите 8"
      puts " - Для начала просмотра списка маршрутов нажмите 9"
      puts " - Для просмотра станций маршрута нажмите 10" 
      puts " - Для просмотра всех станций нажмите 11" 
      puts " - Выход 0"
      command = gets.chomp
      case command
      when "1"
        new_station
      when "2"
        new_train
      when "3"
        route_controller
      when "4"
        if routes.empty? || trains.empty?
          puts "Нет ни одного поезда и ни одного маршрута" 
        else
          get_route
        end
      when "5"
        attempt = 0
        begin
          add_wagon
        rescue RuntimeError
          attempt +=1 
          puts "Позда с таким номером нет! Попытайтесь еще раз."
          retry if attempt < 2
        end
      when "6"
        attempt = 0
        begin
          del_wagon
        rescue RuntimeError
          attempt +=1 
          puts "Позда с таким номером нет! Попытайтесь еще раз."
          retry if attempt < 2
        end
      when "7"
        moving_train
      when "8"
        list_trains
      when "9"
        print_routes
      when "10"
        show_route
      when "11"
        print_stations
      when "0"
        break
      else 
        puts "Неверная комманда"
      end
    end
  end
end

puts "Это симулятор управления ЖД"
ctrl = Controller.new
#ctrl.seed
ctrl.start