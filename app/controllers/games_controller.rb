require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    alph = ("A".."Z").to_a
    @letters = []
    10.times { @letters << alph.sample }
  end

  def score
    @letters = JSON.parse(params[:letters])
    @letters_clean = ""
    @letters.each do |el|
      @letters_clean += "#{el}, "
    end
    @letters_clean = @letters_clean[0, @letters_clean.length - 3]
    @letters_clean += "and #{@letters[-1]}"
    @word = params[:word].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    json_from_web = URI.open(url).read
    @result = JSON.parse(json_from_web)

    # Vérifier si chaque lettre utilisée par l'utilisateur se trouve dans l'array des lettres proposées
    valid_letters = @word.chars.all? { |letter| @letters.include?(letter) }
    # Vérifier si le nombre d'occurrences de chaque lettre utilisée par l'utilisateur est inférieur ou égal au nombre d'occurrences correspondant dans l'array des lettres proposées
    valid_counts = @letters.all? { |letter| @word.count(letter) <= @letters.count(letter) }
    if valid_letters == true && valid_counts == true
      valid_word = true
    else
      valid_word = false
    end

    if valid_word == false
      @answer = "Sorry, but #{@word} can't be built out of #{@letters_clean}"
    elsif @result["found"] == false
      @answer = "Sorry, but #{@word} does not seem to be a valid english word"
    else
      @answer = "Congratulations! #{@word} is a valid english word."
    end
  end
end
