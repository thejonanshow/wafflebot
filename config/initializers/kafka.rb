require 'kafka'

$kafka = Kafka.new(
  ENV['KAFKA_URL'],
  ssl_ca_cert: ENV['KAFKA_TRUSTED_CERT'],
  ssl_client_cert: ENV['KAFKA_CLIENT_CERT'],
  ssl_client_cert_key: ENV['KAFKA_CLIENT_CERT_KEY']
)

Thread.new do
  $kafka.each_message(topic: "pendoreille-6647.wafflebotui") do |message|
    parsed = JSON.parse(message.value)
    ActionCable.server.broadcast("waffles", message: parsed["message"], color: parsed["color"])
  end
end
