# encoding: utf-8
require_relative "maker"
require_relative "instances_counter"

class Train
  NUMBER_FORMAT =/^(([\d]|[a-z]|[а-я]){3}\-?([\d]|[a-z]|[а-я]){2})$/i

  
  include Company
  include InstanceCounter

  attr_reader :speed, :number
  attr_accessor :route, :current_location, :type,  :wagons
  @@all_trains = []
  @@instances = 0

  def valid?
    if number !~ NUMBER_FORMAT
      puts "Формат номера задан неверно!"
      puts "Допустимый формат: XXX-XX или XXXXX, где Х любая буква или цифра"
      raise RuntimeError
    end
    if number.length < 5
      puts "Номер поезда должен содержать не менее 5 символов" 
      raise RuntimeError
    end
    true
  end

  def self.instances
   @@instances
  end

  def self.find(number)
    @@all_trains.find{|train| train.number == number}
  end

  def initialize(number)
    @number = number.to_s
    valid?
    @wagons = []
    @speed = 0
    @current_location = 0
    @@instances += 1
    register_instance
    @@all_trains << self
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