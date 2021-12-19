# encoding: utf-8

class CargoWagon < Wagon

  TYPE = :cargo

  attr_reader :taken_space
  
  def initialize(space, number=1)
    super
    @type = TYPE
  end

  def take_space(val)
    raise "Недостаточно места" if self.free_space < val
    @taken_space += val
  end
end 