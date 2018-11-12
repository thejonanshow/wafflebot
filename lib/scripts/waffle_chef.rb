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

class Switch
  def initialize(pin = nil)
    RPi::GPIO.set_numbering :bcm

    @pin = pin || 26
    RPi::GPIO.setup @pin, :as => :output

    off
  end

  def on
    RPi::GPIO.set_high @pin
  end

  def off
    RPi::GPIO.set_low @pin
  end
end

class Beeper
  def initialize(pin = nil)
    RPi::GPIO.set_numbering :bcm

    @pin = pin || 16
    RPi::GPIO.setup @pin, :as => :input
  end

  def wait
    while RPi::GPIO.low? @pin
      sleep 0.5
      puts "Waiting for beep..."
    end
  end
end

class Motor
  def initialize(step_pin, reverse_pin, delay = 0.001)
    RPi::GPIO.set_numbering :bcm

    @step_pin = step_pin
    @reverse_pin = reverse_pin
    @delay = delay
  end

  def forward(steps = 800)
    RPi::GPIO.setup @step_pin, :as => :output

    steps.times do
      RPi::GPIO.set_high @step_pin
      puts "HIGH"
      sleep @delay
      RPi::GPIO.set_low @step_pin
      puts "LOW"
      sleep @delay
    end
  end

  def backward(steps = 800)
    RPi::GPIO.setup @step_pin, :as => :output
    RPi::GPIO.setup @reverse_pin, :as => :output

    RPi::GPIO.set_high @reverse_pin
    forward(steps)
  ensure
    RPi::GPIO.set_low @reverse_pin
  end
end
