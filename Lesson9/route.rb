# frozen_string_literal: true

require_relative 'instances_counter'
require_relative 'validation'
require_relative 'accessors'

class Route
  include InstanceCounter
  include Acсessors
  include Validation

  attr_accessor :stations

  def initialize(start_station, finish_station)
    @stations = [start_station, finish_station]
    self.class.validate start_station, "presence"
    self.class.validate finish_station, "presence"
    validate!
    register_instance
  end

  # Добавляет промежуточную станцию (перед последней)
  def add_station(station)
    stations.insert(-2, station)
  end

  # Удалет указанную промежуточную станцию (кроме первой и последней)
  def delete_station(station)
    stations.delete(station) if station != stations.first && station != stations.last
    puts 'Станция удалена!'
    show_route
  end

  # Выводит все станци маршрута от первой до последней
  def show_route
    stations.each_with_index { |x, i| puts "#{i + 1}. #{x}" }
  end
end
