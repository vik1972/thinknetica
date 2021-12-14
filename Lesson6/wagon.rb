# encoding: utf-8

class Wagon
  include Company
  
  attr_accessor :number, :type

  def initialize(number)
    @number = number
  end

end 