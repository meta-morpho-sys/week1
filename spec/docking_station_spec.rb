require 'docking_station'

describe DockingStation do
  let(:bike) { double :bike }
  before(:each) do
    allow(bike).to receive(:working?).and_return(true)
    allow(bike).to receive(:broken?).and_return(false)
  end

  def dock_a_bike
    subject.dock(bike)
  end

  def count_broken_bikes
    allow(bike).to receive(:broken?).and_return(true)
    described_class::BROKEN_BIKES_CAPACITY.times { dock_a_bike }
  end

  it { is_expected.to respond_to :release_bike }
  it { is_expected.to respond_to(:dock).with(1).argument }

  describe 'upon initialization' do
    it 'defaults capacity' do
      described_class::DEFAULT_CAPACITY.times { dock_a_bike }
      expect { dock_a_bike }.to raise_error 'Docking station is full.'
    end

    it ' accepts changes to capacity in initialization' do
      ds = DockingStation.new(50)
      expect(ds.capacity).to eq 50
    end
  end

  describe '#release_bike' do

    it 'releases working bikes' do
      double(:bike, working?: true)
      dock_a_bike
      bike = subject.release_bike
      expect(bike).to be_working
    end

    it 'raises an error when there are no bikes available' do
      expect { subject.release_bike }.to raise_error 'No bikes available.'
    end

    it 'does not release broken bikes' do
      allow(bike).to receive(:broken?).and_return(true)
      dock_a_bike
      expect { subject.release_bike }.to raise_error 'No working bikes available.'
    end
  end

  describe '#dock' do
    it 'docks bikes returned by user' do
      expect(dock_a_bike).to eq [bike]
    end

    it 'raises an error when full' do
      subject.capacity.times { dock_a_bike }
      expect { dock_a_bike }.to raise_error 'Docking station is full.'
    end
  end

  describe 'managing of broken bikes' do

    it 'raises an error when there are more than five broken bikes' do
      count_broken_bikes
      expect { dock_a_bike }.to raise_error 'There are five broken bikes. Call the reparation team.'
    end
    it 'releases a broken bike to the van' do
      count_broken_bikes
      expect{subject.send_to_repair(1)}.to change{subject.broken_bikes.length}.from(5).to(4)
    end
  end
end
