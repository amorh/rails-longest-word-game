require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = [*'A'..'Z'].first(10).shuffle
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def score
    # raise
    @input = params[:game].upcase
    @letters = params[:letters].upcase
    @answer = @input.chars.all? { |letter| @input.count(letter) <= @letters.count(letter) }
    if @answer
      if english_word?(@input)
        @score = "Congratulations! #{@input} is a valid english word!"
      else
        @score = "Sorry but #{@input} does not seem to be a valid English word..."
      end
    else
      @score = "Sorry but #{@input} can be built out of #{@letters}"
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
      return json['found']
  end

end
