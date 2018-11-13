require 'kafka'

$kafka = Kafka.new(
  ENV['KAFKA_URL'],
  ssl_ca_cert: ENV['KAFKA_TRUSTED_CERT'],
  ssl_client_cert: ENV['KAFKA_CLIENT_CERT'],
  ssl_client_cert_key: ENV['KAFKA_CLIENT_CERT_KEY']
)

Thread.new do
  count = 0
  colors = %w(blue green red yellow teal gray black)

  loop do
    sleep 2
    count += 1;
    ActionCable.server.broadcast("waffles", message: count, color: colors.sample)
  end
end
