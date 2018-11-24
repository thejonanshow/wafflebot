class WafflesController < ApplicationController
  def new
    data = { message: "start" }.to_json
    $kafka.deliver_message(data, topic: "pendoreille-6647.wafflebot")
  end
end
