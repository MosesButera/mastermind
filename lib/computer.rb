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
  end
end
