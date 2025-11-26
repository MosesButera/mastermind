# Define class Computer inheriting from board.rb
class Computer
  def initialize(name)
    @name = name
  end

  # Generate random number array from the 1296 set of four possible arrays.
  def create_secret_code
    all_codes = create_all_codes
    all_codes.sample
  end

  # Method: create_all_codes
  def create_all_codes
    six_possible_numbers = [1, 2, 3, 4, 5, 6]
    six_possible_numbers.repeated_permutation(4).to_a
  end

  # Method: get_feedback(secret, guess)
  def get_feedback(guess, secret_code)
    # Initialize deep copies that will track changes in guess and secret_code
    guess_copy = Marshal.load(Marshal.dump(guess))
    secret_code_copy = Marshal.load(Marshal.dump(secret_code))
    # initialize counters
    black_peg = 0
    white_peg = 0

    # Black pegs (exact matches)
    guess_copy.each_with_index do |element, index|
      next unless element == secret_code[index]

      black_peg += 1
      index = secret_code_copy.index(element)
      secret_code_copy[index] = nil # to avoid double counting in white peg mark
      # positions as used by setting to null.
    end

    # White pegs (color matches)
    guess_copy.compact.each do |target_element|
      next unless secret_code_copy.include?(target_element)

      white_peg += 1
      index = secret_code_copy.index(target_element)
      secret_code_copy[index] = nil # to avoid double counting.
    end

    # p "[#{black_peg} black peg(s), #{white_peg} white peg(s)]"
    [black_peg, white_peg]
  end

  # Method: check_game_won
  def check_game_won(feedback)
    return unless feedback[0] == 4 && feedback[1].zero?

    'Game is won'
  end

  # Method: filter_possibilities(S, guess, feedback)
  def filter_possibilities(current_set_of_possible_secrets, guess, feedback)
    current_set_of_possible_secrets.select do |element|
      actual_feedback = feedback
      hypothetical_feedback = get_feedback(guess, element)
      actual_feedback == hypothetical_feedback
    end
  end

  # Method: find_next_guess_minimax(S)
  def find_next_guess_minimax(current_set_of_possible_secrets)
    best_guess = 0
    best_score = -1
    all_codes = create_all_codes

    all_codes.each do |guess|
      # The will hold all the feedback/keys and values/codes (from remaining codes not all_codes) that
      # would still remain if the secrete were the code guessed p.
      filtered_codes_partition = Hash.new { |hash, key| hash[key] = [] }

      current_set_of_possible_secrets.each do |hypo_secret|
        hypo_feedback = get_feedback(guess, hypo_secret)
        filtered_codes_partition[hypo_feedback] = [] if filtered_codes_partition[hypo_feedback].nil?
        filtered_codes_partition[hypo_feedback] << hypo_secret
      end

      lengths = []
      # Feedback with worst case
      filtered_codes_partition.each_value do |value|
        lengths << value.length
      end
      worst_case_remaining = lengths.max

      # Score in the worst case/How many How many codes we guarantee eliminate in the worst case.
      score = current_set_of_possible_secrets.length - worst_case_remaining

      # compare score with best score and if best score == score prefer guesses that are in filtered_codes
      if score > best_score || (score == best_score && current_set_of_possible_secrets.include?(guess))
        best_score = score
        best_guess = guess
      end
    end
    best_guess
  end

  # Method: solve_mastermind(secret)
  def solve_mastermind(secret)
    current_set_of_possible_secrets = create_all_codes
    guess = [1, 1, 2, 2]
    guess_count = 0
    guess_history = []
    feedback_history = []
    loop do
      # Start round
      puts "\nGuess: #{guess}"
      guess_count += 1
      puts "\nguess count = #{guess_count}"
      guess_history << guess
      puts "\n Guess History: #{guess_history}"

      # Step 1: make first guess to get response/feedback.
      feedback = get_feedback(guess, secret)
      feedback_history << feedback
      puts "\nFeedback: #{feedback[0]} black, #{feedback[1]} white. Feedback History: #{feedback_history}"

      # Step 2: check if game is won:
      result = check_game_won(feedback)
      if result == 'Game is won'
        puts "\nComputer wins game in #{guess_count} rounds. Secret is #{guess}"
        break
      end

      if guess_count == 12 && result != 'Game is won'
        puts "\nComputer lost! After 12 rounds"
        break
      end

      # Step 3: Filter possible secret codes:
      filtered_set_of_possible_secrets = filter_possibilities(current_set_of_possible_secrets, guess, feedback)
      current_set_of_possible_secrets = filtered_set_of_possible_secrets
      p "Possibilities remaining: #{current_set_of_possible_secrets.length}"

      p "Possibilities remaining: #{current_set_of_possible_secrets}" if current_set_of_possible_secrets.length < 10

      # Step 4:Find next guess using minimax:
      guess = find_next_guess_minimax(current_set_of_possible_secrets)
    end
  end
end
