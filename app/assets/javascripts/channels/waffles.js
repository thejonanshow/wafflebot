App.waffles = App.cable.subscriptions.create("WafflesChannel", {
  connected: function() {
    console.log("Connected...")
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
    if (data["message"] == "go_home") {
      window.location.replace("http://localhost:3000")
    }

    console.log("Received...")
    progress = document.getElementsByClassName('waffle-progress')

    colors = {
      "blue" : "btn-primary",
      "green" : "btn-success",
      "red" : "btn-danger",
      "yellow" : "btn-warning",
      "teal" : "btn-info",
      "gray" : "btn-secondary",
      "black" : "btn-dark"
    }

    new_classes = "btn " + colors[data["color"]] + " btn-lg disabled waffle-progress"

    if (progress.length > 0) {
      progress[0].className = new_classes
      progress[0].innerText = data["message"]
    }
  }
});
