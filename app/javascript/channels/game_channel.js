import consumer from "./consumer";
// var my_var = <%= User.first.email %>
const initGameCable = () => {
  const gameContainer = document.getElementById("game");

  if (gameContainer) {
    const id = gameContainer.dataset.gameId;
    const players = document.querySelectorAll(".player");
    const action = document.querySelector(".action");
    const user = action.dataset.user;
    let current = "";
    consumer.subscriptions.create(
      { channel: "GameChannel", id: id },
      {
        received(data) {
          if (data[4] === "c") {
            const currentBet = document.querySelector(".current-bet");
            currentBet.innerHTML = data;
          } else if (
            data.split(" ")[1].trim() === "loses" ||
            (data.split(" ")[1].trim() === 'class="action-content">' &&
              current != user) ||
            (data.split(" ")[1].trim() === 'class="form-container">' &&
              current === user)
          ) {
            console.log(current == user);
            document.querySelector(".action").innerHTML = data;
          } else {
            players.forEach((player) => {
              if (
                data.split(" ")[0].trim() ===
                `<h1>${player.innerText.trim()}</h1>`
              ) {
                player.innerHTML = data;
                if (data.length > 652) {
                  current = data
                    .split(" ")[0]
                    .trim()
                    .replace(/<\/?[^>]+(>|$)/g, "");
                }
              }
            });
          }
        },
      }
    );
  }
};

export { initGameCable };
