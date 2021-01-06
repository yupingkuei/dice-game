class GamesController < ApplicationController
  def index; end

  def show
    @game = Game.find(params[:id])
  end

  def new; end

  def edit; end
end
