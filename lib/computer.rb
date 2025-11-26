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
    end
  end
end
