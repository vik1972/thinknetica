# encoding: utf-8

class PassengerWagon < Wagon
  
  TYPE = :passenger

  def initialize(number)
    super
    @type = TYPE
  end 

end 