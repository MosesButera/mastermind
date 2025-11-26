# Mastermind Game with Minimax AI Solver

A Ruby implementation of the classic Mastermind code-breaking game featuring an AI solver that uses the minimax algorithm to guarantee solutions within 5 moves.

## Project Summary
This project implements the board game Mastermind where players try to deduce a secret 4-digit code (digits 1-6) within 12 rounds. The game provides feedback through:

    Black pegs: Correct color in correct position
    White pegs: Correct color in wrong position

The project features two game modes:

  1. Code Breaker Mode: You guess the computer's secret code
  2. Code Maker Mode: You create a code and watch the AI solve it using an optimal minimax algorithm

The AI solver is based on Donald Knuth's five-guess algorithm, which guarantees finding any code within 5 attempts by making strategically optimal guesses that minimize the worst-case number of remaining possibilities.

## Quick start
Prerequisites
  Ruby 2.7 or higher
  Bundler (optional, if using Gemfile)

Project Structure

project-root/
├── Gemfile
├── Gemfile.lock
├── README.md
├── main.rb
└── lib/
    └── computer.rb

Installation & Running
  1. Clone the repository
    git clone <your-repo-url>
    cd mastermind-game

  2. Install dependencies (if using Bundler)
    bundle install

  3. Run the game
    ruby main.rb

  4. Follow the prompts

## High-level problem & solution
Problem: Mastermind is a code-breaking game: find a 4-digit secret (digits 1..6) with feedback after each guess in the form of:

    black pegs: correct digit in correct position,

    white pegs: correct digit in wrong position.

There are 6^4 = 1,296 possible codes. The computer must reduce the candidate set each round using feedback and choose the next guess to minimize the worst-case remaining possibilities (minimax).

### High-level solution (why it works):

1. Generate search space: create_all_codes builds all 1296 candidate codes.

2. Compare guess vs secret: get_feedback computes [black, white] using non-destructive copies and marking used pegs to avoid double counting.

3. Eliminate: filter_possibilities keeps only codes consistent with the feedback for the last guess.

4. Choose next guess (minimax): find_next_guess_minimax evaluates each possible guess by partitioning the remaining candidate set by hypothetical feedback, then selects a guess that minimizes the maximum remaining candidate set after the response (the Minimax or Knuth approach).

5. Repeat: solve_mastermind loops until the secret is solved or maximum rounds reached.

This approach is effective because each round eliminates inconsistent codes and the minimax step chooses guesses that reduce the worst-case size of the possibilities, guaranteeing fast convergence (Knuth’s five-guess theorem).

### Data structures & implementation notes

    Codes are arrays of integers, e.g. [1,1,2,2].

    The candidate set is an Array of arrays: [[1,1,1,1], [1,1,1,2], ...].

    Feedback is a small two-element array [black, white].

    Partitioning for minimax uses a Hash keyed by feedback arrays; values are arrays of secrets that would yield that feedback.

## Pseudocode

START

# Setup
Read player name and mode choice (1 = you guess, 2 = computer guesses)

IF mode == 1:
  computer picks secret from all codes
  FOR up to 12 rounds:
    prompt player for guess (four digits 1..6)
    compute feedback = computer.get_feedback(guess, secret)
    print feedback
    if feedback == [4, 0]:
      print "You win"
      break
  end

ELSE IF mode == 2:
  player enters secret
  computer.solve_mastermind(secret)  # loop:
    make initial guess [1,1,2,2]
    get feedback
    if feedback indicates win -> print result
    else filter possibilities to those consistent with feedback
    choose next guess via minimax (choose guess that minimizes worst-case remaining)
  end

END

## How to test manually

1. Start with the player mode (enter 1) and try guessing the secret:

    Enter valid 4-digit guesses using digits 1..6 (e.g., 1122).

    Observe feedback printed as X black, Y white.

    Check that win is detected when you guess correctly.

2. Test computer mode (enter 2):

    Input a valid secret like 1122.

    Watch the computer make guesses and the console show pruning and final success/failure.

3. Edge cases:

    Try invalid inputs (letters, wrong length) — the runner will re-prompt (validation included).

    Try secrets/guesses with repeated digits to confirm white/black accounting.

Happy Code Breaking!