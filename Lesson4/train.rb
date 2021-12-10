# encoding: utf-8
class Train
  attr_reader :speed, :number
  attr_accessor :route, :current_location, :type,  :wagons
 
  
  # Данные методы должны быть доступны всем объектам, 
  # которые знают имя объекта, к которому они обращаются.
  # Т.е. пользователь может узнать на кокой станции сейчас расположен поезд,
  # какая станция была перед этой и какая следующая станция по пути.

  def initialize(number)
    @number = number.to_s
    @wagons = []
    @speed = 0
    @current_location = 0
  end
  
  def push_wagon(wagon)
    self.wagons << wagon if self.type == wagon.type && self.train_stoped? 
  end

  def accelerate(value)
    speed += value
  end 

  def slow(value)
    speed -= value if speed > 0
  end

  def forward
    @current_location += 1 if next_station
  end

  def back
    @current_location -= 1 if previous_station
  end

  def delete_wagon
    wagons.pop if ! wagons.empty? && train_stoped? 
  end

  def get_route(rout)
    @route = rout.stations
    @current_location = 0
  end

  def current_station
    route.stations[current_location]
  end
 
  def previous_station
    if route[current_location] != route.first
      route[current_location-1]
    else
      puts "Это станция начальная"
    end
  end

  def next_station
    if route[current_location] != route.last
      route[current_location+1]
    else
      puts "Эта станция конечная"
    end
  end

  def train_stoped?
    speed.zero?
  end 

end