dictionary = File.read("../dictionary.txt").split(" ")
mistery_word = dictionary.sample()
puts mistery_word


class Game
  attr_accessor :word

  def initialize(string)
    self.word = string
  end

  def play_game
    word_to_guess = self.word
    word_len = word_to_guess.length
    word_holder = Array.new
    num = 0
    while num < word_len
      if (word_to_guess[num] == "-")
        word_holder.push("-")
      else
        word_holder.push("_")
      end
      num += 1
    end
    hanged = 0
    p word_holder
    while hanged != 6
      print "Type a letter: "
      user_letter = gets.chomp!.downcase
      if word_to_guess.downcase.include?(user_letter)
        word_holder.each_with_index do |element, index|
          if word_to_guess[index] == user_letter
            word_holder[index] = user_letter
          end
        end
        if word_holder.join("") == word_to_guess
          puts "You go it! The word was, indeed, \"#{word_to_guess}\"."
          break
        end
      else
        hanged += 1  
      end
      p word_holder
      if hanged == 6
        puts "You've lost, the correct word was \"#{word_to_guess}\"."
      end
    end
  end
end

Game.new(mistery_word).play_game
