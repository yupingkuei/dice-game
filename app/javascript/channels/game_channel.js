import consumer from "./consumer";
// var my_var = <%= User.first.email %>

const initGameCable = () => {
  if (document.getElementById("game")) {
    const gameContainer = document.getElementById("game");
    const background = document.querySelector(".background");
    const id = gameContainer.dataset.gameId;

    if (document.querySelector(".start")) {
      const players = document.querySelectorAll(".player");
      const competitors = document.querySelector(".competitors");
      const action = document.querySelector(".action");
      const user = action.dataset.user;
      let current = "";
      consumer.subscriptions.create(
        { channel: "GameChannel", id: id },
        {
          received(data) {
            // current bet condition
            if (data.split(" ")[1].trim() === 'class="current-bet-content">') {
              const currentBet = document.querySelector(".current-bet");
              currentBet.innerHTML = data;
            }
            // loses
            else if (data.split(" ")[1].trim() === 'class="loser">') {
              //shows opponents dice
              competitors.classList.remove("hide");
              document.querySelector(".action").innerHTML = data;
            }
            // action window condition
            else if (
              // fills action based on current turn
              (data.split(" ")[1].trim() === 'class="action-content">' &&
                current != user) ||
              (data.split(" ")[1].trim() === 'class="form-container">' &&
                current === user) ||
              data.split(" ")[1].trim() === 'class="gameover">'
            ) {
              document.querySelector(".action").innerHTML = data;
            }
            // player's dice
            else if (data.split(" ")[1].trim() === 'class="player-name">') {
              console.log(data.split(" ")[1]);
              //hides opponents dice
              competitors.classList.add("hide");
              players.forEach((player) => {
                if (
                  //checks if player email matches incoming post email
                  player.querySelector(".email").innerText ===
                  data
                    .match(/<h2 class="email">.*<\/h2>/g)[0]
                    .replace(/<\/?[^>]+(>|$)/g, "")
                ) {
                  player.innerHTML = data;
                  if (data.split(" ")[6] === `class="turn-icon"><i`) {
                    // assigns current turn
                    current = data
                      .match(/<h2 class="email">.*<\/h2>/g)[0]
                      .replace(/<\/?[^>]+(>|$)/g, "");
                  }
                }
              });
            } else if (data.split(" ")[1].trim() === 'class="queue">') {
              console.log(data);
              gameContainer.innerHTML = data;
            } else if (data === "start game") {
              console.log(data);
              location.reload();
            }
          },
        }
      );
    } else {
      consumer.subscriptions.create(
        { channel: "GameChannel", id: id },
        {
          received(data) {
            if (data.split(" ")[1].trim() === 'class="queue">') {
              gameContainer.innerHTML = data;
            } else if ((data = "start game")) {
              location.reload();
            }
          },
        }
      );
    }
  }
};

export { initGameCable };
