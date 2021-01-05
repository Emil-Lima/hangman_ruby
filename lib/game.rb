# frozen_string_literal: true

require 'yaml'

# Module containing all functions to run the game
module AllFunctions
  def gettable_word
    dictionary = File.read('../dictionary.txt').split(' ')
    dictionary.sample
  end

  def word_holder(word)
    word_len = word.length
    num = 0
    while num < word_len
      if word[num] == '-'
        word_array.push('-')
      else
        word_array.push('_')
      end
      num += 1
    end
  end

  def round
    letter = user_letter
    if original_word.include?(letter)
      right_letters.push(letter)
      word_array.each_with_index do |_element, index|
        word_array[index] = letter if original_word[index] == letter
      end
    else
      wrong_letters.push(letter)
      self.num_rounds += 1
    end
  end

  def user_letter
    print 'Type a letter: '
    gets.chomp!.downcase
  end

  def save_or_continue
    print 'Do you want to save (s) the current game or continue (c)?: '
    gets.chomp!
  end

  def save_game
    Dir.mkdir 'output' unless Dir.exist? 'output'
    @filename = '1_game.yaml'
    File.open("output/#{@filename}", 'w') { |file| file.write save_to_yaml }
  end

  def save_to_yaml
    YAML.dump(
      'original_word' => original_word,
      'available_letters' => available_letters, # Maybe delete this
      'right_letters' => right_letters,
      'wrong_letters' => wrong_letters,
      'word_array' => word_array,
      'num_rounds' => self.num_rounds
    )
  end

  def load_game
    file = YAML.safe_load(File.read('output/1_game.yaml'))
    self.original_word = file['original_word']
    self.right_letters = file['right_letters']
    self.wrong_letters = file['wrong_letters']
    self.word_array = file['word_array']
    self.num_rounds = file['num_rounds']
    game_logic
  end

  def new_game
    self.original_word = gettable_word
    word_holder(original_word)
    game_logic
  end

  def game_logic
    p word_array
    while self.num_rounds < 6
      if save_or_continue == 'c'
        round
        p word_array
        if original_word == word_array.join('')
          puts 'You win!'
          break
        end
      else
        save_game
        break
      end
      if self.num_rounds == 6
        puts "You have lost. The right word was #{original_word}."
        break
      end
    end
  end
end

# class that contains the logic of the game
class Game
  include AllFunctions

  attr_accessor :original_word, :wrong_letters, :right_letters, :available_letters, :num_rounds, :word_array

  def initialize
    self.available_letters = ('a'..'z').to_a
    self.right_letters = []
    self.wrong_letters = []
    self.word_array = []
    self.num_rounds = 0
    play_game
  end

  def play_game
    print 'Play a new game (n) or load an existing game file (l).'
    user_says = gets.chomp!
    new_game if user_says == 'n'
    load_game if user_says == 'l'
  end
end

Game.new
