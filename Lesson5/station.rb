# encoding: utf-8
require_relative "instances_counter"

class Station

  include InstanceCounter

  attr_accessor :trains
  attr_reader :name

  @@all_stations =[]
  
  #@@instances = 0

  # def self.instances
  #   @@instances
  # end

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    @trains = []
    register_instance
    @@all_stations << self
  end

  def take_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train) if trains.include?(train)
  end

  def show_trains
    trains.each {|train| puts "Поезд № #{train.number}, #{train.type} количество вагонов: #{train.wagons.size}"}
  end

  #Возвращает массиввсех поездов на станции в текущий момент времени, по типу
  def trains_by(type)
    trains.select { |train| train.type == type }
  end
end
