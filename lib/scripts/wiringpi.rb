PIN = 21
STEPS = 10

require 'wiringpi'

io = WiringPi::GPIO.new
io.mode(PIN, OUTPUT)

STEPS.times do
  io.write(PIN, HIGH)
  puts "HIGH"
  sleep(2)
  io.write(PIN, LOW)
  puts "LOW"
end
