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
end
