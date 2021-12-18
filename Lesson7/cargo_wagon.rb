# encoding: utf-8

class CargoWagon < Wagon

  TYPE = :cargo

  attr_reader :count_space, :taken_space
  
  def initialize(count_space, number=1)
    super
    @type = TYPE
  end
  
  
  attr_writer :count_space

  def take_space(val)
    raise "Недостаточно места" if self.free_space < val
    @taken_space += val
  end
end 