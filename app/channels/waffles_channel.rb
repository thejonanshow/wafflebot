class WafflesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "waffles"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
