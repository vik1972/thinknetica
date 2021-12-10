
class PassengerTrain < Train
  
  TYPE = :passenger

  def initialize(number)
    super
    @type = TYPE
  end
  
end