# frozen_string_literal: true

require_relative 'maker'
require_relative 'instances_counter'
require_relative 'train'
require_relative 'wagon'
require_relative 'station'
require_relative 'route'
require_relative 'cargo_train'
require_relative 'passenger_train'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

class Controller
  attr_accessor :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def seed
    cargo_train = %w[c11-c1 c22-s2 c33-34]
    cargo_train.each { |train| trains << CargoTrain.new(train) }
    passenger_train = %w[p01-01 p02-w3 p03-w3]
    passenger_train.each { |train| trains << PassengerTrain.new(train) }
    puts 'Trains:'
    trains.each { |x| puts "#{x.number}, #{x.type}, #{x.wagons}" }
    routes << Route.new('Калининград', 'Москва')
    routes << Route.new('Калининград', 'Санк-Петеребург')
    routes << Route.new('Новосибирск', 'Москва')
    routes.each { |x| puts "#{x.stations.first} - #{x.stations.last}" }
    cities = %w[Калининград Москва Санк-Петеребург Новосибирск Волгоград
                Саратов Витебск Вильнус Новгород Черняховск]
    cities.each { |city| stations << Station.new(city) }
    puts 'Станции:'
    stations.each_with_index { |x, i| puts "#{i + 1}. #{x.name}" }
  end

  def print_stations
    if stations.empty?
      puts 'Станций нет'
    else
      puts 'Станции:'
      stations.each_with_index { |x, i| puts "#{i + 1}. #{x.name}" }
    end
  end

  def print_trains
    puts 'Поезда'
    trains.each_with_index { |x, i| puts "#{i + 1}. #{x.number}" }
  end

  def print_routes
    puts 'Маршруты'
    routes.each_with_index do |x, i|
      puts "#{i + 1}. #{x.stations.first} - #{x.stations.last}"
    end
  end

  def new_station
    attempt = 0
    begin
      puts 'Введите название станции'
      name = gets.chomp.strip
      stations << Station.new(name.capitalize)
      puts "Станция #{name.capitalize} создана"
    rescue RuntimeError
      attempt += 1
      puts 'Попытайтесь еще раз.'
      retry if attempt < 3
    end
    puts 'Станция не создана' if attempt == 3
  end

  def informations_of_train
    puts 'Введите номер поезда'
    name = gets.chomp.to_s
    puts "Укажите необходимый тип поезда ('грузовой' или 'пассажирский')"
    type = gets.chomp.strip
    puts 'Укажите количество вагонов'
    count = gets.chomp.to_i
    [name, type, count]
  end

  def build_train(name, count, type)
    case type
    when 'грузовой'
      puts 'Укажите общий объём вагона'
      space = gets.chomp.to_i
      train = CargoTrain.new(name)
      (1..count).each do |i|
        wagon = CargoWagon.new(space, i)
        train.push_wagon(wagon)
      end
    when 'пассажирский'
      puts 'Укажите количество мест в вагоне'
      space = gets.chomp.to_i
      train = PassengerTrain.new(name)
      (1..count).each do |i|
        wagon = PassengerWagon.new(space, i)
        train.push_wagon(wagon)
      end
    end
    trains.push(train)
    # train
  end

  def new_train
    attempt = 0
    begin
      name, type, count = informations_of_train
      case type
      when 'грузовой'
        build_train(name, count, type)
        puts "Поезд номер #{name}, тип - грузовой, вагонов #{count} создан."
      when 'пассажирский'
        build_train(name, count, type)
        puts "Поезд номер #{name}, тип - пассажирский, вагонов #{count} создан."
      else
        puts 'Неверный тип вагона'
        raise RuntimeError
      end
    rescue RuntimeError
      attempt += 1
      puts 'Попытайтесь еще раз.'
      retry if attempt < 3
    end
    puts 'Поезд не создан' if attempt == 3
  end

  def add_train_to_station(train)
    if train.route.nil?
      puts 'У поезда нет маршрута'
    elsif train.route.size <= train.current_location
      puts 'Это конечная станция маршрута'
    else
      number_station = train.current_location
      name_station = train.route[number_station]
      stations.each do |station|
        station.take_train(train) if station.name == name_station
      end
    end
  end

  def del_train_to_station(train)
    if train.route.nil?
      puts 'У поезда нет маршрута'
    else
      number_station = train.current_location
      name_station = train.route[number_station]
      stations.each do |station|
        station.send_train(train) if station.name == name_station
      end
    end
  end

  def moving_train(train)
    puts 'Выберете направление (1 - одна станция вперед, 0 - прекратить движение, и -1 - станция назад)'
    direction = gets.chomp.to_i
    case direction
    when 1
      del_train_to_station(trains[train - 1])
      trains[train - 1].forward
      add_train_to_station(trains[train - 1])
    when -1
      del_train_to_station(trains[train - 1])
      trains[train - 1].back
      add_train_to_station(trains[train - 1])
    else
      puts 'Движение прекращено'
    end
  end

  def start_moving_train
    loop do
      if trains.empty? || routes.empty?
        puts 'Нет ни одиного поезда и ни одного маршрута'
      else
        puts 'Введите порядковый номер поезда или 0 для выхода'
        print_trains
        train = gets.chomp.to_i
        break if train.zero?

        if train > trains.size
          puts 'Поезда с таким номером нет'
          break
        else
          moving_train(train)
        end
      end
    end
  end

  def informations_of_route
    print_stations
    puts 'Введите 0, если надо ввести новую станцию или 1 чтобы создать маршрут из имеющихся станций'
    comand = gets.chomp.to_i
    new_station if comand.zero?
    print_stations
    puts 'Введите порядковый номер первой станции маршрута'
    first = gets.chomp.to_i
    puts 'Введите порядковый номер последней станции маршрута'
    last = gets.chomp.to_i
    if first.zero? || last > stations.size
      puts 'Станций с такими номерами нет'
      raise RuntimeError
    end
    [first, last]
  end

  def new_route
    attempt = 0
    begin
      if stations.size >= 2
        first, last = informations_of_route
        routes << Route.new(stations[first - 1].name, stations[last - 1].name)
        puts "Ноый маршрут: #{stations[first - 1].name} - #{stations[last - 1].name}"
      else
        puts 'Недостаточно станций для составления маршрута.'
        puts 'Вернитесь в меню и создайте минимум 2 станции'
        raise
      end
    rescue RuntimeError
      attempt += 1
      puts 'Попытайтесь еще раз.'
      retry if attempt < 3
    end
    puts 'Маршрут не создан' if attempt == 3
  end

  def check_route
    if routes.empty?
      puts 'Нет маршрутов для редактирования. Создайте хотя бы один маршрут'
    else
      print_routes
      puts 'Введите порядковый номер маршрута'
      route = gets.chomp.to_i
      if route < 1 || route > routes.size
        puts 'Маршрут с таким номером отсутствует'
      else
        route
      end
    end
  end

  def delete_station_of_route
    puts 'Введите номер станции'
    routes[route - 1].show_route
    pos = gets.chomp.to_i
    if pos >= routes[route - 1].stations.size || pos == 1
      puts 'Нельзя удалить первую или последнюю станцию маршрута'
    else
      name = routes[route - 1].stations[pos - 1]
      routes[route - 1].delete_station(name) if routes[route - 1].stations.include?(name)
    end
  end

  def push_station_of_route
    puts 'Введите номер станции'
    print_stations
    pos = gets.chomp.to_i
    if pos.positive? && pos <= stations.size
      routes[route - 1].add_station(stations[pos - 1].name)
    else
      puts 'Станции с таким номером нет'
    end
  end

  def edit_route
    route = check_route
    unless route.nil?
      puts 'Если вы хотите удалить станцию из маршрута введите 1, если добавить - 2'
      action = gets.chomp.to_i
      case action
      when 1
        delete_station_of_route
      when 2
        push_station_of_routes
      end
    end
  end

  def route_controller
    puts 'Введите 1 для создания маршрута'
    puts 'Введите 2 для редактирования маршрута'
    puts 'Введите 0 для возвращения в главное меню'
    chose = gets.chomp
    case chose
    when '1'
      new_route
    when '2'
      edit_route
    else
      puts 'Вы возвращены в главное меню'
    end
  end

  def take_route
    puts 'Введите порядковый номер поезда в списке'
    print_trains
    train = gets.chomp.to_i
    puts 'Введите порядковый номер маршрута в списке'
    print_routes
    route = gets.chomp.to_i
    if (train < 1 || train > trains.size) || (route < 1 || route > routes.size)
      puts 'Такого маршрута или поезда нет в списке'
    else
      trains[train - 1].take_route(routes[route - 1])
      station = routes[route - 1].stations.first
      stations.each do |x|
        x.trains << trains[train - 1] if x.name == station && !x.trains.include?(trains[train - 1])
      end
    end
  end

  def add_wagon
    if trains.empty?
      puts 'Список поездов пустой. Создайте новый поезд'
    else
      puts 'Введите порядковый номер поезда'
      print_trains
      train = gets.chomp.to_i
      raise RuntimeError if train < 1 || train > trains.size

      number_wagon = trains[train - 1].wagons.size
      if trains[train - 1].type == :cargo
        puts 'Укажите общий объм вагона'
        space = gets.chomp.to_i
        wagon = CargoWagon.new(space, number_wagon + 1)
      else
        puts 'Введите количестово мест в вагоне'
        space = gets.chomp.to_i
        wagon = PassengerWagon.new(space, number_wagon + 1)
      end
      trains[train - 1].push_wagon(wagon) if train.positive? && train <= trains.size
    end
  end

  def del_wagon
    if trains.empty?
      puts 'Список поездов пустой. Создайте новый поезд'
    else
      puts 'Введите порядковый номер поезда'
      print_trains
      train = gets.chomp.to_i
      raise RuntimeError if train < 1 || train > trains.size

      trains[train - 1].delete_wagon
    end
  end

  def print_station_trains(station, type)
    case type
    when 'cargo'
      puts "Грузовые поезда станции #{stations[station - 1].name}"
      stations[station - 1].trains_by(:cargo).each { |train| print_train_wagons(train) }
    when 'passenger'
      puts "Пассажирские поезда станции #{stations[station - 1].name}"
      stations[station - 1].trains_by(:passenger).each { |train| print_train_wagons(train) }
    else
      puts "Все поезда станции #{stations[station - 1].name}"
      stations[station - 1].each_train { |train| print_train_wagons(train) }
    end
  end

  def list_trains
    if trains.empty? || stations.empty?
      puts 'Нет станций и поездов'
    else
      puts 'Выберите станцию для просмотра всех поездов на ней'
      print_stations
      station = gets.chomp.to_i
      if station < 1 || station > stations.size
        puts 'Неверный номер станции'
      else
        puts 'Введите all для вывода всех поездов станции'
        puts 'Введите cargo для вывода грузовых поездов станции'
        puts 'Введите passenger для вывода пассажирских поездов станции'
        chose = gets.chomp.to_str
        print_station_trains(station, chose)
      end
    end
  end

  def show_route
    print_routes
    puts 'Введите порядковый номер маршрута'
    route = gets.chomp.to_i
    if route < 1 || route > routes.size
      puts 'Маршрут с таким номером отсутствует'
    else
      routes[route - 1].show_route
    end
  end

  def list_wagons
    begin
      print_trains
      puts 'Введите порядковый номер поезда, вагоны которого хотите посмотреть'
      number = gets.chomp.to_i
      if number < 1 || number > trains.size
        puts 'Вагона с таким номером нет'
        raise RuntimeError
      end
    rescue StandardError
      puts 'Вагона с таким номером нет'
    end
    print_train_wagons(trains[number - 1])
  end

  def print_wagons(train)
    if train.wagons.size.zero?
      puts 'У поезда нет вагонов'
    else
      if train.type == :cargo
        type = 'грузовой'
        taken_space = 'занятый объем:'
        free_space = 'свбодный объем:'
      else
        type = 'пассажирский'
        taken_space = 'занято мест:'
        free_space = 'свободно мест:'
      end
      train.each_train_wagon do |wagon|
        puts "Номер вагона: #{wagon.number},тип вагона: #{type},
        #{free_space} #{wagon.free_space}, #{taken_space} #{wagon.taken_space}"
      end
    end
  end

  def print_train_wagons(train)
    type = if train.type == :cargo
             'грузовой'
           else
             'пассажирский'
           end
    puts "Номер поезда: #{train.number}, тип: #{type}, количестово вагонов: #{train.wagons.size}"
    print_wagons(train)
  end

  def take_place
    # бронирование мест
    puts 'Введите порядковый номер поезда в списке'
    print_trains
    number = gets.chomp.to_i
    raise 'Такого номера в списке нет!' if number < 1 || number > trains.size

    train = trains[number - 1]
    puts "Номер поезда: #{train.number}, количестово вагонов: #{train.wagons.size}"
    puts 'Введите номер вагона, в котором хотите забронировать место'
    number_wagon = gets.chomp.to_i
    if train.type == :passenger
      train.each_train_wagon { |wagon| wagon.take_seat if wagon.number == number_wagon }
    else
      begin
        puts 'Введите объем груза'
        val = gets.chomp.to_i
        train.each_train_wagon { |wagon| wagon.take_space(val) if wagon.number == number_wagon }
      rescue RuntimeError
        puts 'Недостаточно свободного места в выбранном вагоне'
      end
    end
  end

  def print_menu
    puts
    puts ' - Для создания станции введите 1'
    puts ' - Для создания поезда введите 2'
    puts ' - Для работы с маршрутом(создание/редактирование) введите 3'
    puts ' - Для назначения маршрута поезду введите 4'
    puts ' - Для добавления вагона к поезду введите 5'
    puts ' - Для отцепления вагона от поезда введите 6'
    puts ' - Для начала перемещения по маршруту нажмите 7'
    puts ' - Для начала просмотра списка поездов на станции нажмите 8'
    puts ' - Для начала просмотра списка маршрутов нажмите 9'
    puts ' - Для просмотра станций маршрута нажмите 10'
    puts ' - Для просмотра информации о вагонах поезда нажмите 11'
    puts ' - Для для бронирования места в вагоне нажмите 12'
    puts ' - Для просмотра всех станций нажмите 13'
    puts ' - Выход 0'
  end

  def start
    loop do
      print_menu
      command = gets.chomp
      case command
      when '1'
        new_station
      when '2'
        new_train
      when '3'
        route_controller
      when '4'
        if routes.empty? || trains.empty?
          puts 'Нет ни одного поезда и ни одного маршрута'
        else
          take_route
        end
      when '5'
        attempt = 0
        begin
          add_wagon
        rescue RuntimeError
          attempt += 1
          puts 'Позда с таким номером нет!'
          retry if attempt < 2
        end
      when '6'
        attempt = 0
        begin
          del_wagon
        rescue RuntimeError
          attempt += 1
          puts 'Позда с таким номером нет!'
          retry if attempt < 2
        end
      when '7'
        start_moving_train
        # moving_train
      when '8'
        list_trains
      when '9'
        print_routes
      when '10'
        show_route
      when '11'
        list_wagons
      when '12'
        take_place
      when '13'
        print_stations
      when '0'
        break
      else
        puts 'Неверная комманда'
      end
    end
  end
end

puts 'Это симулятор управления ЖД'
ctrl = Controller.new
ctrl.seed
ctrl.start
