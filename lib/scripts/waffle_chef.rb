require "rpi_gpio"

class WaffleChef
  attr_reader :beeper, :swing, :lift, :valve, :pump, :flip

  def initialize
    @beeper = Beeper.new(16)
    @swing = Motor.new(6, 5, 0.0005)
    @lift = Motor.new(19, 13, 0.0005)
    @valve = Switch.new(14)
    @pump = Switch.new(15)
    @flip = Motor.new(21, 20, 0.00005)

    RPi::GPIO.setup 26, as: :output
    RPi::GPIO.set_high 26
  end

  def cook

    puts "Raising lid..."
    @lift.forward(800)
    sleep 15

    puts "Deploying dispenser arm..."
    @swing.forward(5500)
    sleep 7

    puts "Opening valve..."
    @valve.on
    puts "Pumping..."
    @pump.on
    sleep 3
    puts "Closing valve..."
    @valve.off
    puts "Stopping pump..."
    @pump.off

    puts "Retracting dispenser arm..."
    @swing.backward(5500)
    sleep 7

    puts "Closing lid..."
    @lift.forward(800)
    sleep 25

    puts "Flipping iron..."
    @flip.forward(42000)
    sleep 10
    puts "Flipping iron..."
    @flip.backward(42000)
    sleep 10

    puts "Opening lid..."
    @lift.forward(800)
    sleep 25

    puts "Done!"
  end
end

class Switch
  def initialize(pin)
    RPi::GPIO.set_numbering :bcm

    @pin = pin
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
  def initialize(pin)
    RPi::GPIO.set_numbering :bcm

    @beeped = false

    @pin = pin
    RPi::GPIO.setup @pin, as: :input, pull: :down
  end

  def beep
    @beeped = true
  end

  def unbeep
    @beeped = false
  end

  def wait
    while (!@beeped) || (RPi::GPIO.low? @pin)
      sleep 0.5
      puts "Waiting for beep..."
    end
  end
end

class Motor
  def initialize(step_pin, reverse_pin, delay)
    RPi::GPIO.set_numbering :bcm

    @step_pin = step_pin
    @reverse_pin = reverse_pin
    @delay = delay
  end

  def forward(steps)
    RPi::GPIO.setup @step_pin, :as => :output

    steps.times do
      RPi::GPIO.set_high @step_pin
      sleep @delay
      RPi::GPIO.set_low @step_pin
      sleep @delay
    end
  end

  def backward(steps)
    RPi::GPIO.setup @step_pin, :as => :output
    RPi::GPIO.setup @reverse_pin, :as => :output

    RPi::GPIO.set_high @reverse_pin
    forward(steps)
  ensure
    RPi::GPIO.set_low @reverse_pin
  end
end
