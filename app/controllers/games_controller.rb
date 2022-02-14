require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = Array.new(9) { ('A'..'Z').to_a.sample }
  end

  def score
    @answer = params[:answer]
    @grid = params[:data]
    if included?(@grid, @answer)
      response = URI.open("https://wagon-dictionary.herokuapp.com/#{@answer}")
      json = JSON.parse(response.read)
      if json['found']
        @score = @answer.chars.count
        @message = "Well done, your score is: #{@score}"
      else
        @message = 'Bad luck, that\'s not an English word - try again!'
      end
    end
  end

  def included?(grid, answer)
    @answer.chars.all? { |letter| @answer.count(letter.upcase) <= @grid.count(letter.upcase) }
  end
end
