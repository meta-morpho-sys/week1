require_relative 'bike'
require_relative 'docking_station'

class Van
  VAN_CAPACITY = 5

  def initialize
    @transported_bikes = []
  end
  def retrieve_bike(docking_station)
    bike = docking_station.repair_bike
    @transported_bikes << bike
  end
end
