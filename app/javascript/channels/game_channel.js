import consumer from "./consumer";

const initGameCable = () => {
  const gameContainer = document.getElementById("game");

  if (gameContainer) {
    const id = gameContainer.dataset.gameId;

    consumer.subscriptions.create(
      { channel: "GameChannel", id: id },
      {
        received(data) {
          if (data[1] === "h") {
            gameContainer.innerHTML = data;
          } else {
            const action = document.querySelector(".action");
            action.innerHTML = data;
          }

          // gameContainer.innerHTML = data;
        },
      }
    );
  }
};

export { initGameCable };
