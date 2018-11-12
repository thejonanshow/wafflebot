require "rpi_gpio"

class WaffleChef
  def initialize
    @ready = false
    @beeper = Beeper.new
    @swing = Motor.new(6, 5, 0.0005)
    @lift = Motor.new(26, 19, 0.1) 
    @valve = Switch.new(14)
    @pump = Switch.new(15)
    @flip = Motor.new(21, 20, 0.0005)
  end

  def cook
    @beeper.wait unless @ready
    @ready = true

    @lift.forward(10)
    sleep 10

    @swing.forward(1000)
    sleep 10

    @valve.on
    @pump.on
    sleep 3
    @valve.off
    @pump.off

    @swing.backward(1000)
    sleep 10

    @lift.backward(10)
    sleep 10

    @flip.forward(1000)
    @beeper.wait
    @flip.backward(1000)
    sleep 10

    @lift.forward(10)
  end
end

# wait for beep unless :ready (?) how do we know if we were already on? temp?
# open wafflemaker - need to know if we're open already
# swing arm in
# dispense batter
# swing arm out
# close lid
# rotate iron
# wait for beep
# rotate iron
# open lid
# play music! zelda chest opening!!!
