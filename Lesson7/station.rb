# encoding: utf-8
require_relative "instances_counter"

class Station
  NAME_FORMAT =/[\A]&[\d]|[a-z]|[а-я]/i

  include InstanceCounter

  attr_accessor :trains
  attr_reader :name
  @@all_stations =[]

  
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

  def each_train(&block)
    trains.each {|train| yield(train)}
  end

  def take_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train) if trains.include?(train)
  end

  def show_trains
    @trains.each {|train| puts "Поезд № #{train.number}, #{train.type} количество вагонов: #{train.wagons.size}"}
  end

  #Возвращает массиввсех поездов на станции в текущий момент времени, по типу
  def trains_by(type)
    trains.select { |train| train.type == type }
  end

  private

  def validate!
    if @name.size == 0 || @name !~NAME_FORMAT
      puts "Название станция не может быть пустой строкой или числом."
      raise RuntimeError
    end
    @@all_stations.each do |station|
      if station.name.downcase == @name.downcase
        puts "Станция с таким названием уже есть"
        raise RuntimeError
      end
    end
  end

end

