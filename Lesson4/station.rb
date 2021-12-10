# encoding: utf-8

class Station
  attr_accessor :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
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
