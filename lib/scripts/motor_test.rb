require 'rpi_gpio'

steps = ARGV[0].to_i
steps ||= 1600
direction = ARGV[1].to_i

class Pump
  def initialize(pin = nil)
    RPi::GPIO.set_numbering :bcm

    @pin = pin || 26
    RPi::GPIO.setup @pin, :as => :output
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

    puts "BEEP"
  end
end

class Motor
  def initialize(step_pin, reverse_pin, delay = nil)
    RPi::GPIO.set_numbering :bcm

    @step_pin = step_pin
    @reverse_pin = reverse_pin
    @delay = delay || 0.001
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

at_exit {
  puts "Cleaning up..."
  RPi::GPIO.reset
  RPi::GPIO.reset
  puts "Done"
}

def raise_lid
  Motor.new(6, 5, 0.0005).backward(4800)
end
