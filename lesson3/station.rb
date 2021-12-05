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

  #Выводит список всех поездов на станции в текущий момент времени, по типу
  def show_trains_type(type)
    if type == "псж"
      puts "Список пассажирский поездов на станции #{@name}:"
    else
      puts "Список грузовых поездов на станции #{@name}:"
    end
    @trains.each {|train| puts "Train number of #{train.number}"  if train.type_train == type}
  end
end
