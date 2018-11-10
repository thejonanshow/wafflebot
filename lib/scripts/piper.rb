require 'pi_piper'

PIN = 21
STEPS = 3

include PiPiper

pin = PiPiper::Pin.new(pin: PIN, direction: :out)

STEPS.times do
  pin.on
  puts "HIGH"
  sleep 2
  pin.off
  puts "LOW"
end
