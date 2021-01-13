import consumer from "./consumer";

const initGameCable = () => {
  const gameContainer = document.getElementById("game");

  if (gameContainer) {
    const id = gameContainer.dataset.gameId;

    consumer.subscriptions.create(
      { channel: "GameChannel", id: id },
      {
        received(data) {
          console.log(data[12]);
          if (data[12] === "b") {
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
