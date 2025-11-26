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
end
