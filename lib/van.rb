require_relative 'bike'
require_relative 'docking_station'

class Van
  VAN_CAPACITY = 5
  attr_reader :transported_bikes

  def initialize
    @transported_bikes = []
  end

  def retrieve_bike(docking_station)
    raise 'Van is full.' if full?
    bike = docking_station.send_to_repair
    @transported_bikes << bike
  end

  def deliver_bike(num, destination)
    @transported_bikes.pop(num)

  end

  private
  def full?
    @transported_bikes.size >= VAN_CAPACITY
  end
end
