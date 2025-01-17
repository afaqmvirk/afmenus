# frozen_string_literal: true

# lib/afmenus.rb

require "io/console"  # For capturing user input
require_relative "afmenus/version"

module Afmenus
  # Clear the console
  def self.clear_console
    print "\e[H\e[2J"
  end

  # Print the menu with the current selection highlighted
  def self.print_menu(menu_items, current_row, current_col)
    clear_console
    menu_items.each_with_index do |row_items, row|
      row_items.each_with_index do |item, col|
        if row == current_row && col == current_col
          print "\e[7m#{item.center(item.length + 2)}\e[0m"
        else
          print "#{item.center(item.length + 2)}"
        end
        print " | " unless col == row_items.length - 1
      end
      puts
    end
    puts "\nUse Arrow Keys to move, Enter to select, Ctrl+C to exit."
  end

  # Prompt the user with the menu
  def self.prompt(menu_items)
    current_row = 0
    current_col = 0

    print_menu(menu_items, current_row, current_col)

    loop do
      char = STDIN.getch

      case char
      when "\e"   # Escape sequence
        next_char = STDIN.getch
        if next_char == "["
          arrow_key = STDIN.getch
          case arrow_key
          when "A" # Up arrow
            current_row -= 1 if current_row > 0
          when "B" # Down arrow
            current_row += 1 if current_row < menu_items.length - 1
          when "C" # Right arrow
            current_col += 1 if current_col < menu_items[current_row].length - 1
          when "D" # Left arrow
            current_col -= 1 if current_col > 0
          end
        end
      when "\r", "\n" # Enter key
        return menu_items[current_row][current_col]
      when "\u0003"    # Ctrl+C
        return nil
      end

      print_menu(menu_items, current_row, current_col)
    end
  end
end
