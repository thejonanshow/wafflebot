require "rpi_gpio"

class Motor
  def initialize(step:, reverse:, delay: nil)
    RPi::GPIO.set_numbering :bcm

    @step = step
    @reverse = reverse
    @delay = delay || 0.001
  end

  def forward(steps = 800)
    RPi::GPIO.setup @step, :as => :output

    steps.times do
      RPi::GPIO.set_high @step
      puts "HIGH"
      sleep @delay
      RPi::GPIO.set_low @step
      puts "LOW"
      sleep @delay
    end
  end

  def backward(steps = 800)
    RPi::GPIO.setup @step, :as => :output
    RPi::GPIO.setup @reverse, :as => :output

    RPi::GPIO.set_high @reverse
    forward(steps)
  ensure
    RPi::GPIO.set_low @reverse
  end
end
