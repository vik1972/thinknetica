# encoding: utf-8
require_relative "instances_counter"

class Route
  include InstanceCounter
  attr_accessor :stations

  def initialize(start_station, finish_station)
    @stations = [start_station, finish_station]
    register_instance
  end

  #Добавляет промежуточную станцию (перед последней)
  def add_station(station)
    self.stations.insert(-2, station)
  end

  #Удалет указанную промежуточную станцию (кроме первой и последней)
  def delete_station(station)
    self.stations.delete(station) if station != stations.first && station != stations.last
    puts "Станция удалена!"
    self.show_route
  end

 #Выводит все станци маршрута от первой до последней
  def show_route
    stations.each_with_index { |x, i| puts "#{i+1}. #{x}" }
  end

end

