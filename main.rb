#!/usr/bin/ruby
require 'io/console'
#require 'colorize'
require 'matrix'

module Direction
  UP = 1
  DOWN = 2
  RIGHT = 4
  LEFT = 3
end

class Table

 public
  def draw
    print ((" %#{4}s " * @size + "\n") * @size) % @table.map { |e| e ? e.to_s : "_" * 4  }
  end

  def initialize size
    @size = size
    @table = [nil] * size * size
    _gen_rnd
    self.move Direction::DOWN
  end #end_new

  def mainloop
      while true
        input = IO.console.getch
        self.move case input
                              when 'w' #UP
                                Direction::UP
                              when 's' #DOWN
                                Direction::DOWN
                              when 'a' #LEFT
                                Direction::LEFT
                              when 'd' #RIGHT
                                Direction::RIGHT
                              else
                                raise "Invalid input!"
                           end
      end
  end

 protected
  def _move direction = Direction::LEFT
   case direction
   when Direction::LEFT
     rows = self.rows
   when Direction::RIGHT
     rows = self.rows.map{|arr| arr.reverse}
   when Direction::UP
     rows = self.cols
   when Direction::DOWN
     rows = self.cols.map { |arr| arr.reverse }
   end #end case
   __add  rows
   rows.each do |row|
     (1...row.length).each {|x|
       pivot = row[x]
       (0...x).to_a.reverse.each {|y|
         begin
           row[y] = pivot
           row[y+1] = nil
         end if row[y].nil?
       }
     }
   end #end _ block

  if direction == Direction::RIGHT then rows = rows.map { |arr| arr.reverse  }
  elsif direction == Direction::DOWN
    rows = rows.map { |arr| arr.reverse  }
    rows = Matrix[*rows].transpose.to_a
  elsif direction == Direction::UP
    rows = Matrix[*rows].transpose.to_a
  end #end if

  return_ = []
  rows.each do |row|
    return_ += row
  end #end block
    if return_ != @table
      @changed = true
    else
      @changed = false
    end
    return_ ##return the corrected table

 end #end   _move


  def rows index = nil
    return begin
      rel = []
      @size.times { |val|
        rel << @table[((val+1) * @size - @size)..(@size * (val+1) - 1)]
      }
      index ? rel[index] : rel

    end
  end # end_rows

  def cols index = nil
    amtrx = Matrix[*rows].transpose.to_a
    index ? amtrx[index] : amtrx
  end #end_cols

  def move direction
    system'clear'
    @table = _move direction
    if  @changed then
      _gen_rnd
    end #end if
    draw
    if losed? then
      puts "Game over - Your lose"
      exit
    end
  end #end_move

private
  def losed?
    losed_row = losed_col = true
    rows = self.rows
    cols = self.cols
    rows.each { |row|
      (0...row.length-1 ).each {|i|
        losed_row = false if row[i] == row[i+1] or !(row[i] && row[i+1])
      }
    }
    cols.each {|col|
      (0...col.length-1 ).each{|i|
        losed_col = false if (col[i] == col[i+1]) or !(col[i] && col[i+1])
      }
    }
    losed_col & losed_row
  end #end  losed?

  def _gen_rnd
    blanks = []
    @table.map.with_index { |value,index|
      blanks << index if value.nil?
    }
    return if blanks.count == 0
    rand_index = rand blanks.count
    @table[blanks[rand_index]] =  rand >= 0.763 ? 4 : 2
  end

  def __add rows
    rows.each do |row|
      (0...row.length - 1).each do |index|
        next if row[index].nil?
        (row[index] *= 2
        row[index+1] = nil
        ) if row[index] == row[index +1]
      end #end block
    end #end loop
  end

end
table = Table.new 5
table.mainloop
