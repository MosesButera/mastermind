require_relative 'lib/computer'

puts 'Game Start :)'
puts "\nPlease enter player name"
player_name = gets.chomp
puts "\n#{player_name} please enter 1 for code breaker or 2 code maker to start game"
choice = gets.chomp

if choice.nil? || choice != '1' || choice != '2' || !choice.is_a?(String)
  'Please enter valid choice: 1 for code breaker or 2 for code maker'
else
  choice = gets.chomp
end

# Player guesses secret code:
if choice == '1'
  computer = Computer.new('Computer')
  secret = computer.create_secret_code
  # Initialize round counter to keep track of rounds.
  round = 0
  guess_history = []
  feedback_history = []
  loop do
    round += 1
    puts "\nROUND# #{round}\nPlease enter guess. For instance 1122 no spaces."
    guess = gets.chomp.to_i

    # Error handling guess variable
    if guess.nil? || !guess.is_a?(Integer)
      puts "\nPlease enter valid guess. For instance 1234 no spaces."
    else
      guess = guess.to_s.chars.map { |char| char.to_i }
      guess_history << guess
      feedback = computer.get_feedback(guess, secret)
      feedback_history << feedback
      puts "\nFeedback: #{feedback[0]} black, #{feedback[1]} white. Guess History: #{guess_history}. Feedback History: #{feedback_history}"
      result = computer.check_game_won(feedback)
    end
  end
end
