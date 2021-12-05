# encoding: utf-8
class Route
  attr_reader :start_station, :finish_station, :stations

  def initialize(start_station, finish_station)
    @start_station = start_station
    @finish_station = finish_station
    @stations = [start_station, finish_station]
  end

  #Добавляет промежуточную станцию (перед последней)
  def add_station(station)
    @stations.insert(-2, station)
  end

  #Удалет указанную промежуточную станцию (кроме первой и последней)
  def delete_station(station)
    @stations.delete(station) if station != @start_station && station != @finish_station
  end

 #Выводит все станци маршрута от первой до последней
  def show_route
    @stations.each { |station| puts station }
  end

end

