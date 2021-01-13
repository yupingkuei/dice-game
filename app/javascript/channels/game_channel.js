import consumer from "./consumer";

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
          console.log(data.split(" ")[4].trim() === 'class="simple_form');
          if (data[4] === "c") {
            const currentBet = document.querySelector(".current-bet");
            currentBet.innerHTML = data;
          }
          // if (data[12] === "b") {
          //   gameContainer.innerHTML = data;
          // } else {
          else if (
            data.split(" ")[1].trim() === "loses" ||
            data.split(" ")[0].trim() === "<p><i" ||
            data.split(" ")[4].trim() === 'class="simple_form'
          ) {
            document.querySelector(".action").innerHTML = data;
            console.log("action update");
          } else {
            console.log(data.split(" ")[0].trim());
            players.forEach((player) => {
              if (
                data.split(" ")[0].trim() ===
                `<h1>${player.innerText.trim()}</h1>`
              ) {
                console.log("match");
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
