# frozen_string_literal: true

require_relative 'instances_counter'
require_relative 'validation'
require_relative 'accessors'

class Station
  include InstanceCounter
  include Acсessors
  include Validation
  
  NAME_FORMAT = /\A&\d|[a-z]|[а-я]/i.freeze

  attr_accessor :trains
  attr_reader :name

  @@all_stations = []

  def self.all
    @@all_stations
  end

  def initialize(name)
    @name = name
    self.class.validate name, "presence"
    self.class.validate name, "format", /\A&\d|[a-z]|[а-я]/
    validate!
    @trains = []
    register_instance
    @@all_stations << self
  end

  def each_train(&block)
    trains.each(&block) if block_given?
  end

  def take_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train) if trains.include?(train)
  end

  def show_trains
    @trains.each { |train| puts "Поезд № #{train.number}, #{train.type} количество вагонов: #{train.wagons.size}" }
  end

  # Возвращает массиввсех поездов на станции в текущий момент времени, по типу
  def trains_by(type)
    trains.select { |train| train.type == type }
  end
end
