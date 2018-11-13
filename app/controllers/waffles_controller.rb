class WafflesController < ApplicationController
  def new
    $kafka.deliver_message("cook", topic: "pendoreille-6647.wafflebot")
  end
end
