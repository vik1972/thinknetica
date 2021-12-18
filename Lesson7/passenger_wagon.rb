# encoding: utf-8

class PassengerWagon < Wagon

  TYPE = :passenger
  attr_reader :count_space, :taken_space


  def initialize(count_spase, number=1)
    super
    @type = TYPE
  end
  
  attr_writer :count_space, :taken_space

  def take_seat
    raise "Недостаточно места" if self.free_space < 1
    @taken_space += 1
  end

end 