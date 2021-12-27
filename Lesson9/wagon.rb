# frozen_string_literal: true

class Wagon
  include Company

  attr_accessor :number, :type

  def initialize(space, number = 1)
    @number = number
    @space = space
    @taken_space = 0
  end

  def free_space
    @space - taken_space
  end
end
