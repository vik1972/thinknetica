
class CargoTrain < Train
  
  TYPE = :cargo

  def initialize(number)
    super
    @type = TYPE
  end

end