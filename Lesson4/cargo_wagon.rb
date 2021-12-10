# encoding: utf-8

class CargoWagon < Wagon
  
  TYPE = :cargo

  def initialize(number)
    super
    @type = TYPE
  end

end 