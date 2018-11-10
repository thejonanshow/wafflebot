require 'adafruit-servo-driver'

channel = 0
naptime = 3
loops = 1

pwm = PWM.new(0x40, true)
pwm.set_pwm_freq(50)

loops.times do
  pwm.set_pwm(channel, 0, 465)
  sleep(naptime)
  pwm.set_pwm(channel, 0, 1)
  sleep(naptime)
end
