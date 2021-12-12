
class PassengerTrain < Train
  include InstanceCounter
  TYPE = :passenger

  def initialize(number)
    super
    @type = TYPE
  end
  
end