#encoding: utf-8
=begin
require './Block'

b = Block.new 3, 4, 3, 4, 5, nil, 2, 4, 7
puts b.get_elem 0, 0
b.put_elem 0, 0, 4
puts b.get_elem 0, 0
puts "\n"
puts b.elem 1, 2
puts b.include? nil
puts nil.to_s.class
puts nil.to_s.inspect
puts "BLABLABLA\n\n"
=end
=begin
(0..80).each do |i|
	puts i / 27 * 3 + i % 9 / 3
end
=end
=begin
(0..80).each do |i|
	puts (i % 3 + i / 9 * 3) % 9
end
=end
=begin
aa = bb = 91
puts aa
puts bb
puts (bb + 2)
=end

require './Sudoku'
=begin
s0 = Sudoku.new '3,4,0,0,0,6,0,7,0,0,8,0,0,0,0,9,3,0,0,0,2,0,3,0,0,6,0,0,0,0,0,1,0,0,0,0,0,9,7,3,6,4,8,5,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,8,0,9,0,0,0,0,9,2,3,7,8,5'
#=begin
s = Sudoku.new '9,8,4,0,0,0,0,0,0,0,0,2,5,0,0,0,4,0,0,0,1,9,0,4,0,0,2,0,0,6,0,9,7,2,3,0,0,0,3,6,0,2,0,0,0,2,0,9,0,3,5,6,1,0,1,9,5,7,6,8,4,2,3,4,2,7,3,5,1,8,9,6,6,3,8,0,0,9,7,5,1'
#=begin
s.put_elem 8, 8, 11111
s.test_object_id 80
=end

s2 = Sudoku.new '5,6,0,0,0,0,0,0,0,0,0,0,0,0,4,6,0,0,0,0,0,7,5,0,2,3,0,8,5,3,0,1,0,0,6,0,6,0,0,0,3,2,9,0,0,0,0,9,0,0,0,1,0,0,3,0,7,1,0,8,0,0,0,0,1,0,0,0,3,0,0,7,0,0,6,0,7,9,0,0,1'
s3 = Sudoku.new '3,1,8,0,0,5,4,0,6,0,0,0,6,0,3,8,1,0,0,0,6,0,8,0,5,0,3,8,6,4,9,5,2,1,3,7,1,2,3,4,7,6,9,5,8,7,9,5,3,1,8,2,6,4,0,3,0,5,0,0,7,8,0,0,0,0,0,0,7,3,0,5,0,0,0,0,3,9,6,4,1'
s4 = Sudoku.new '7,6,2,0,0,8,0,0,1,9,8,0,0,0,0,0,0,6,1,5,0,0,0,0,0,8,7,4,7,8,0,0,3,1,6,9,5,2,6,0,0,9,8,7,3,3,1,9,8,0,0,4,2,5,8,3,5,0,0,1,6,9,2,2,9,7,6,8,5,3,1,4,6,4,1,9,3,2,7,5,8'

#puts s2.possible_cells(3)
#puts s2.candidates 8, 6
#puts s2.candidates_for_cell 78
#puts "get elem: " << s2.elem(8, 5)
#puts s2.get_candidates_for_sudoku.inspect
#puts s0.locked_candidates_1_from_block(7, 1).to_s
#puts s4.locked_candidates_2_from_col(5, 4).to_s
s2.solve
s2.solve
s2.solve
puts s2.get_candidates_for_sudoku.inspect
s2.get_sudoku
#puts s2.last_digit 0, 32
#puts s2.get_house_cells_from_cell(0).inspect

=begin
(2...4).each do |r|
	(0...9).each do |c|
		puts s2.hidden_single(r, c)
		puts "\n"
	end
end
=end

#puts s2.get_col_cells(4,4).inspect
#puts s2.get_other_col_cells(4,4).inspect
#puts s2.get_row_cells(5, 4).inspect
#puts s2.get_elem_from_cell(80)
#puts s2.get_block_number_from_cell 47
=begin
b = Block.new 1,2,3,4,5,6,7,8,9
b.get_object_id
b.put_elem 1, 1, 9
b.get_object_id
=end
=begin
s3 = Sudoku.new ""
=end
=begin
s5 = Sudoku.new '0,4,9,1,3,2,0,0,0,0,8,1,4,7,9,0,0,0,3,2,7,6,8,5,9,1,4,0,9,6,0,5,1,8,0,0,0,7,5,0,2,8,0,0,0,0,3,8,0,4,6,0,0,5,8,5,3,2,6,7,0,0,0,7,1,2,8,9,4,5,6,3,9,6,4,5,1,3,0,0,0'
s5.hidden_pair_from_col 8, 2
s6 = Sudoku.new '5,0,0,6,2,0,0,3,7,0,0,4,8,9,0,0,0,0,0,0,0,0,5,0,0,0,0,9,3,0,0,0,0,0,0,0,0,2,0,0,0,0,6,0,5,7,0,0,0,0,0,0,0,3,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,7,0,0,6,8,0,5,7,0,0,0,2'
s6.hidden_pair_from_col 5, 3
s7 = Sudoku.new '0,0,0,0,6,0,0,0,0,0,0,0,0,4,2,7,3,6,0,0,6,7,3,0,0,4,0,0,9,4,0,0,0,0,6,8,0,0,0,0,9,6,4,0,7,6,0,7,0,5,0,9,2,3,1,0,0,0,0,0,0,8,5,0,6,0,0,8,0,2,7,1,0,0,5,0,1,0,0,9,4'
s7.hidden_pair_from_row 0, 2

s8 = Sudoku.new '0,3,0,0,0,0,0,1,0,0,0,8,0,9,0,0,0,0,4,0,0,6,0,8,0,0,0,0,0,0,5,7,6,9,4,0,0,0,0,9,8,3,5,2,0,0,0,0,1,2,4,0,0,0,2,7,6,0,0,5,1,9,0,0,0,0,7,0,9,0,0,0,0,9,5,0,0,0,4,7,0'
s8.hidden_pair_from_col 8, 4
puts s8.get_candidates_for_sudoku.to_s
=end
