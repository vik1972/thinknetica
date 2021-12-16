# encoding: utf-8
require_relative "instances_counter"

class Station


  include InstanceCounter

  attr_accessor :trains
  attr_reader :name
  @@all_stations =[]

  def validate!
    if @name.size == 0 
      puts "Название станция не может быть пустой строкой."
      raise RuntimeError
    end
    @@all_stations.each do |station|
      if station.name == @name
        puts "Станция с таким названием уже есть"
        raise RuntimeError
      end
    end
  end

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    validate!
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

