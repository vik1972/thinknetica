# encoding: utf-8

class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  #Принимает поезд
  def take_train(train)
    @trains << train
  end

  #Отправлет поезд
  def send_train(train)
    @trains.delete(train) if @trains.include?(train)
  end

  #Выводит список всех поездов на станции в текущий момент времени
  def show_trains
    @trains.each {|train| puts "Train number of #{train.number}" }
  end

  #Возвращает массиввсех поездов на станции в текущий момент времени, по типу
  def show_trains_type
    passenger_trains = @trains.select { |train| train.type_train == "пассажирский"}
    freight_trains = @trains.select { |train| train.type_train == "грузовой"}
  end
end
