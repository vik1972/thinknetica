# encoding: utf-8

class Wagon
  include Company
  
  attr_accessor :number, :type

  def initialize(space, number=1)
    @number = number
    @count_space = space
    @taken_space = 0
  end

  def free_space
    count_space - taken_space
  end

end 