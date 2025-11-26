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
