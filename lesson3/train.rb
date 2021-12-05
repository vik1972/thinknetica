# encoding: utf-8
class Train
  attr_reader :speed, :count_wagons, :type_train, :number

  def initialize(number, type_train, count_wagons)
    @number = number
    @type_train = type_train
    @count_wagons = count_wagons
    @speed = 0
  end

  #Увеличивает скорость на величину агрумента - speed
  def accelerate(speed)
    @speed += speed
  end 

  #Уменьшает скорость на величину агрумента - speed
  def slow(speed)
    @speed -= speed 
    @speed = 0 if @speed < 0
  end

  #Прицепляет один вагон
  def add_count_wagons
    if @speed == 0 
      @count_wagons += 1
    else
      "Во время движения нельзя прицеплять вагоны"
    end
  end

  #Отцепляет один вагон
  def reduce_count_wagons
    if @speed == 0 
      @count_wagons -= 1 
    else
      "Во время движения нельзя отцеплять вагоны"
    end
  end

  #Получает маршрут следования
  def get_route(route)
    @route = route
    @current_location = 0
  end

  #Пермещается на одну станцию вперед по маршруту
  def forward
    @current_location += 1 if next_station
  end

  #Пермещается на одну станцию назад по маршруту
  def back
    @current_location -= 1 if previous_station
  end

  #Возвращает текущую станцию, на основе маршрута
  def current_station
    @route.stations[@current_location]
  end

   #Возвращает предыдущую станцию, на основе маршрута
  def previous_station
    if  @route.stations[@current_location] != @route.stations.first
      @route.stations[@current_location - 1] 
    else
      puts "This is the starting station"
    end
  end

  #Возвращает следующую станцию, на основе маршрута
  def next_station
    if @route.stations[@current_location] != @route.stations.last
      @route.stations[@current_location +1]
    else
      puts "This is the finishing station"
    end
  end

end
 