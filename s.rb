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
s = Sudoku.new '1,2,3,4,5,6,7,8,9,1,1,1,1,1,1,1,1,1,1,2,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1'
s.put_elem 8, 8, 11111
s.test_object_id 80
=end

s2 = Sudoku.new '5,6,0,0,0,0,0,0,0,0,0,0,0,0,4,6,0,0,0,0,0,7,5,0,2,3,0,8,5,3,0,1,0,0,6,0,6,0,0,0,3,2,9,0,0,0,0,9,0,0,0,1,0,0,3,0,7,1,0,8,0,0,0,0,1,0,0,0,3,0,0,7,0,0,6,0,7,9,0,0,1'
#puts s2.possible_cells(3)
puts s2.possible_numbers 8, 6
puts s2.possible_numbers_for_cell 78
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
