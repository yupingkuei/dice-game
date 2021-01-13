import consumer from "./consumer";
// var my_var = <%= User.first.email %>
const initGameCable = () => {
  const gameContainer = document.getElementById("game");

  if (gameContainer) {
    const id = gameContainer.dataset.gameId;
    const players = document.querySelectorAll(".player");
    const action = document.querySelector(".action");

    consumer.subscriptions.create(
      { channel: "GameChannel", id: id },
      {
        received(data) {
          const turn = document.querySelector(".turn");
          const currentTurn = turn.dataset.currentTurn;
          if (currentTurn === "true") {
            console.log("yes");
          }
          if (currentTurn === "false") {
            console.log("no");
          }
          // console.log(currentTurn);
          // console.log(data.split(" "));
          // console.log(data.split(" ")[1].trim() == 'class="action-content"');
          if (data[4] === "c") {
            const currentBet = document.querySelector(".current-bet");
            currentBet.innerHTML = data;
          } else if (
            data.split(" ")[1].trim() === "loses" ||
            (data.split(" ")[1].trim() === 'class="action-content">' &&
              currentTurn === "false") ||
            (data.split(" ")[1].trim() === 'class="form-container">' &&
              currentTurn === "true")
          ) {
            document.querySelector(".action").innerHTML = data;
            // console.log("action update");
          } else {
            // console.log(data.split(" ")[0].trim());
            players.forEach((player) => {
              if (
                data.split(" ")[0].trim() ===
                `<h1>${player.innerText.trim()}</h1>`
              ) {
                // console.log("match");
                player.innerHTML = data;
              }
            });
          }
        },
      }
    );
  }
};

export { initGameCable };
