
class CargoTrain < Train
  NUMBER_FORMAT =/^\w{3}\-*\w{2}$/i
  include InstanceCounter
  TYPE = :cargo

  def initialize(number)
    super
    @type = TYPE
  end
  
end