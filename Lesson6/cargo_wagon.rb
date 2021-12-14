# encoding: utf-8

class CargoWagon < Wagon

  TYPE = :cargo

  def initialize(number)
    @type = TYPE
    #valid?
    attempt = 0
    # begin 
    # rescue RuntimeError
    #   attempt +=1 
    #   puts "Попытайтесь еще раз"
    #   retry if attempt < 2
    # end
    super
  end

  
end 