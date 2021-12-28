# frozen_string_literal: true

class PassengerWagon < Wagon
  TYPE = :passenger
  attr_accessor :taken_space

  def initialize(spase, number = 1)
    super
    @type = TYPE
  end

  def take_seat
    raise 'Недостаточно места' if free_space < 1
    
    @taken_space += 1
  end
end
