#encoding: utf-8

require './Block'

# Klasse zum Darstellen von Sudokus. Erbt von Block, da viele Funktionen von dort gebraucht werden.
class Sudoku < Block

	# Erstellt ein Sudoku. Eingabe muss ein String von 81 kommaseparierten Zahlen als Strings sein.
	# Wenn eine Zelle leer ist, muss "0" angegeben werden. Andere mögliche Eingabe: leeres Sudoku (leerer String)
	def initialize sudoku_string
		unless sudoku_string.strip =~ /^(\d,){80}\d$/ || sudoku_string == ""
			abort "Eingabe ist kein Sudoku!"
		end

		length = 9
		
		# Initialisiert Reihen-, Spalte-, Elemente- und Blöcke-Array (Blöcke-Array beinhaltet Objekte vom Typ Block)
		@elements = Array.new length ** 2
		@rows = init_2dim_array length
		@cols = init_2dim_array length
		@candidates = Array.new length ** 2

		@blocks = []
		(0...length).each do |i|
			@blocks[i] = Block.new
		end
		
		# Fügt die Zahlen in das Sudoku ein
		i = 0
		sudoku_string.strip.each_char do |char|
			if char == ","
				i += 1
			else
				block_number = get_block_number_from_cell i
				block_row = i / 9 % 3
				block_col = i % 3
				
				@blocks[block_number].put_elem block_row, block_col, char
				c = @blocks[block_number].elem block_row, block_col
				@elements[i] = c
				@rows[i / 9][i % 9] = c
				@cols[i % 9][i / 9] = c
			end
		end

		# Falls leeres Sudoku, füge in Reihen-, Spalten- und Elemente-Array auch Nullen ein
		# (Referenzen auf dieselben Objekte wie im Blöcke-Array)
		if sudoku_string == ""
			(0...length ** 2).each do |i|
				c = @blocks[get_block_number_from_cell i].elem (i / 9 % 3), (i % 3)
				@elements[i] = c
				@rows[i / 9][i % 9] = c
				@cols[i % 9][i / 9] = c
			end
		end

		(0...length ** 2).each do |i|
			@candidates[i] = candidates_for_cell i	
		end
=begin		
		# Testausgabe, die noch gelöscht werden muss
		cell = i
		puts @blocks[cell / 27 * 3 + cell % 9 / 3].elem(cell / 9 % 3, cell % 3).object_id
		puts @rows[cell / 9][cell % 9].object_id
		puts @cols[cell % 9][cell / 9].object_id
		puts @elements[i].object_id
=end
	end
	
	# Gibt Blocknummer zur Zelle (Angabe von Koordinaten) aus
	def get_block_number row, col
		return row / 3 * 3 + col / 3
	end

	# Gibt Blocknummer zur Zelle aus
	def get_block_number_from_cell cell
		return cell / 27 * 3 + cell % 9 / 3
	end

	# Prüft, ob Zahl in Reihe vorkommt
	def include_in_row? row, number
		return @rows[row].include? number.to_s
	end
	
	# Prüft, ob Zahl in Spalte vorkommt
	def include_in_col? col, number
		return @cols[col].include? number.to_s
	end

	# Prüft, ob Zahl in Block vorkommt
	def include_in_block? block, number
		return @blocks[block].include? number
	end

	# Prüft, ob Zahl in Zelle vorkommt
	def include_in_cell? row, col, number
		return @rows[row][col] == number.to_s
	end
	
	# Fügt Zahl in Zelle ein (Angabe von Zellennummer (von links nach rechts und von oben nach unten)
	def put_elem_in_cell cell, neuer_wert
		put_elem (cell / 9), (cell % 9), neuer_wert
	end

	# Gibt Zahl aus Zelle aus
	def get_elem_from_cell cell
		return @elements[cell]
	end

	# Fügt Element in Sudoku ein (Angabe von Koordinaten der Zelle)
	def put_elem row, col, neuer_wert
		@rows[row][col].replace neuer_wert.to_s
		# Entferne neuen Wert aus Zellen des Kandidatenarrays in selber Zeile, Spalte und selbem Block
		@candidates[row * 9 + col] = []
		get_other_house_cells(row, col).each do |i|
			@candidates[i].delete neuer_wert
		end
	end

	# Prüft, ob Zelle leer ist
	def cell_is_empty? cell
		return @elements[cell] == "0"
	end
	
	# Prüft, ob Zelle (Angabe der Koordinaten) leer ist
	def empty? row, col
		return @rows[row][col] == "0"
	end

	# Gibt Kandidatenarray aus
	def get_candidates_for_sudoku
		return @candidates
	end

	# Gibt Zellen aus, die für angegebene Zahl möglich ist
	def possible_cells number
		possible_cells = []
		
		# Trage nicht mögliche Stellen ein
		(0...9 ** 2).select { |i| cell_is_empty?(i) && !@rows[i / 9].include?(number.to_s) && !@cols[i % 9].include?(number.to_s) && !@blocks[get_block_number_from_cell i].include?(number) }.each do |i|
				
			possible_cells << i
		end

		# mögliche Stellen
		return possible_cells
	end

	# Gibt mögliche Zahlen für die Zelle (Angabe der Koordinaten) aus
	def candidates row, col

		# Wenn Zelle nicht leer ist, gibt es keine möglichen Zahlen
		if !empty?(row, col)
			return []
		end

		possible_numbers = *(1..9)
		
		# Prüfe, welche Zahlen nicht möglich sind
		cell = row * 9 + col
		(1..9).each do |i|
			if @rows[row].include? i.to_s
				possible_numbers.delete i
			elsif @cols[col].include? i.to_s
				possible_numbers.delete i
			elsif @blocks[get_block_number row, col].include? i
				possible_numbers.delete i
			end
		end

		return possible_numbers
	end

	# Gibt mögliche Zahlen für die Zelle aus
	def candidates_for_cell cell
		candidates (cell / 9), (cell % 9)
	end

	# Gibt die letzte mögliche Zahl aus
	def naked_single row, col
		return naked_single_for_cell (row * 9 + col)
	end

	# Gibt die letzte mögliche Zahl für eine Zelle aus
	def naked_single_for_cell cell
		return @candidates[cell].length == 1 ? @candidates[cell][0].to_i : false
	end

	# Gibt Häuserzellen aus
	def get_house_cells row, col
		house_cells = get_row_cells(row, col) + get_col_cells(row, col) + get_block_cells(row, col)
		return house_cells.uniq!
	end

	# Gibt Häuserzellen aus
	def get_house_cells_from_cell cell
		get_house_cells (cell / 9), (cell % 9)
	end

	# Gibt Häuserzellen aus (ohne angegebene)
	def get_other_house_cells row, col
		return get_house_cells(row, col) - [row * 9 + col]
	end

	# Gibt Häuserzellen aus (ohne angegebene)
	def get_other_house_cells_from_cell cell
		return get_house_cells_from_cell - [cell]
	end

	# Gibt Zellen der Reihe aus
	def get_row_cells row, col
		row_cells = []
		(row * 9...row * 9 + 9).each do |i|
			row_cells << i
		end
		return row_cells
	end

	# Gibt Zellen der Reihe aus
	def get_row_cells_from_cell cell
		get_row_cells (cell / 9), (cell % 9)
	end

	# Gibt Zellen der Reihe aus
	def get_row_cells_from_row row
		get_row_cells row, 0
	end

	# Gibt Zellen der Reihe (ohne angegebene) aus
	def get_other_row_cells row, col
		return get_row_cells(row, col) - [row * 9 + col]
	end

	# Gibt Zellen der Reihe (ohne angegebene) aus
	def get_other_row_cells_from_cell cell
		return get_row_cells_from_cell(cell) - [cell]
	end
	
	# Gibt Zellen der Spalte aus
	def get_col_cells row, col
		col_cells = []
		(0...9).each do |i|
			col_cells << i * 9 + col
		end
		return col_cells
	end

	# Gibt Zellen der Spalte aus
	def get_col_cells_from_cell cell
		get_col_cells (cell / 9), (cell % 9)
	end

	# Gibt Zellen der Spalte aus
	def get_col_cells_from_col col
		get_col_cells 0, col
	end

	# Gibt Zellen der Spalte (ohne angegebene) aus
	def get_other_col_cells row, col
		return get_col_cells(row, col) - [row * 9 + col]
	end

	# Gibt Zellen der Spalte (ohne angegebene) aus
	def get_other_col_cells_from_cell cell
		return get_col_cells_from_cell(cell) - [cell]
	end

	# Gibt Zellen des Blocks aus
	def get_block_cells row, col
		block_cells = []
		block_number = get_block_number row, col
		(row / 3 * 3...row / 3 * 3 + 3).each do |r|
			(col / 3 * 3...col / 3 * 3 + 3).each do |c|
				block_cells << r * 9 + c
			end
		end
		return block_cells
	end

	# Gibt Zellen des Blocks aus
	def get_block_cells_from_cell cell
		get_block_cells (cell / 9), (cell % 9)
	end

	# Gibt Zellen des Blocks aus
	def get_block_cells_from_block block
		get_block_cells (block / 3 * 3), (block % 3 * 3)
	end

	# Gibt Zellen des Blocks (ohne angegebene) aus
	def get_other_block_cells row, col
		return get_block_cells(row, col) - [row * 9 + col]
	end

	# Gibt Zellen des Blocks (ohne angegebene) aus
	def get_other_block_cells_from_cell cell
		return get_block_cells_from_cell(cell) - [cell]
	end

	# Hidden Single
	def hidden_single row, col
		#a = false
		@candidates[row * 9 + col].each do |candidate|
			if get_other_row_cells(row, col).select { |i| !@candidates[i].empty? && @candidates[i].include?(candidate) }.empty? \
				|| get_other_col_cells(row, col).select { |i| !@candidates[i].empty? && @candidates[i].include?(candidate) }.empty? \
				|| get_other_block_cells(row, col).select { |i| !@candidates[i].empty? && @candidates[i].include?(candidate) }.empty?
				
				return candidate.to_i
			end
		end
		return false
	end

	# Hidden Single aus Zelle
	def hidden_single_from_cell cell
		hidden_single (cell / 9), (cell % 9)
	end

	# Locked Candidates Type 1
	def locked_candidates_1 row, col, number
		locked_candidates_1_from_block get_block_number(row, col), number
	end

	# Locked Candidates Type 1
	def locked_candidates_1_from_block block, number
		block_cells = get_block_cells_from_block block
		block_cells_with_number = block_cells.select { |i| @candidates[i].include?(number) }
		
		return_bool = false

		if block_cells_with_number.empty?
			return return_bool
		end

		block_cell_rows = block_cells_with_number.map { |i| i / 9 }
		
		only_in_row = block_cell_rows.count(block_cell_rows[0]) == block_cell_rows.length ? true : false

		if only_in_row
			number_of_deleted_items = 0
			get_other_row_cells_from_cell(block_cells_with_number[0]).select { |i| !block_cells_with_number.include?(i) }.each do |i|
				deleted_item = @candidates[i].delete number
				number_of_deleted_items += 1 if !deleted_item.nil?
			end
			return_bool = true if number_of_deleted_items > 0
		end

		block_cell_cols = block_cells_with_number.map { |i| i % 9 }

		only_in_col = block_cell_cols.count(block_cell_cols[0]) == block_cell_cols.length ? true : false
		
		if only_in_col
			number_of_deleted_items = 0
			get_other_col_cells_from_cell(block_cells_with_number[0]).select { |i| !block_cells_with_number.include?(i) }.each do |i|
				deleted_item = @candidates[i].delete number
				number_of_deleted_items += 1 if !deleted_item.nil?
			end
			return_bool = true if number_of_deleted_items > 0
		end
		
		return return_bool
	end

	# Locked Candidates Type 2
	def locked_candidates_2_from_row row, number
		row_cells = get_row_cells_from_row row
		row_cells_with_number = row_cells.select { |i| @candidates[i].include?(number) }
		if row_cells_with_number.empty?
			return false
		end

		row_cell_blocks = row_cells_with_number.map { |i| get_block_number_from_cell i }

		only_in_block = row_cell_blocks.count(row_cell_blocks[0]) == row_cell_blocks.length ? true : false

		if only_in_block
			number_of_deleted_items = 0
			get_block_cells_from_block(row_cell_blocks[0]).select { |i| !row_cells_with_number.include?(i) }.each do |i|
				deleted_item = @candidates[i].delete number
				number_of_deleted_items += 1 if !deleted_item.nil?
			end
			return true if number_of_deleted_items > 0
		end

		return false	
	end

	# Locked Candidates Type 2 aus Spalte
	def locked_candidates_2_from_col col, number
		col_cells = get_col_cells_from_col col
		col_cells_with_number = col_cells.select { |i| @candidates[i].include?(number) }
		if col_cells_with_number.empty?
			return false
		end

		col_cell_blocks = col_cells_with_number.map { |i| get_block_number_from_cell i }

		only_in_block = col_cell_blocks.count(col_cell_blocks[0]) == col_cell_blocks.length ? true : false

		if only_in_block
			number_of_deleted_items = 0
			get_block_cells_from_block(col_cell_blocks[0]).select { |i| !col_cells_with_number.include?(i) }.each do |i|
				deleted_item = @candidates[i].delete number
				number_of_deleted_items += 1 if !deleted_item.nil?
			end
			return true if number_of_deleted_items > 0
		end

		return false
	end

	def solve 
		# 1: Hidden Singles
		(0...9 ** 2).each do |i|
			hs = hidden_single_from_cell i
			if hs != false
				put_elem_in_cell i, hs
				puts "Hidden Single in Zelle " << i.to_s << ", Zahl " << hs.to_s
			end
		end
		
		# 2: Locked Candidates Type 1
		(0...9).each do |b|
			(1..9).each do |i|
				lc1 = locked_candidates_1_from_block b, i
				if lc1 != false
					puts "Locked Candidates Type 1 in Block " << b.to_s << ", Zahl " << i.to_s
				end
			end
		end
		
		# 3: Locked Candidates Type 2: Reihen
		(0...9).each do |r|
			(1..9).each do |i|
				lc2 = locked_candidates_2_from_row r, i
				if lc2 != false
					puts "Locked Candidates Type 2 in Reihe " << r.to_s << ", Zahl " << i.to_s
				end
			end
		end

		# 4: Locked Candidates Type 2: Spalten
		(0...9).each do |c|
			(1..9).each do |i|
				lc2 = locked_candidates_2_from_col c, i
				if lc2 != false
					puts "Locked Candidates Type 2 in Spalte " << c.to_s << ", Zahl " << i.to_s
				end
			end
		end
	end

	# Testfunktion, die noch entfernt werden muss. Gibt Object-Id einer Zellen aus (zum Überprüfen,
	# ob in den einzelnen Arrays dasselbe Objekt verwendet wird).
	def test_object_id cell
		puts "Block: Object_id " << @blocks[cell / 27 * 3 + cell % 9 / 3].elem(cell / 9 % 3, cell % 3).object_id.to_s
		puts "Reihe: Object_id " << @rows[cell / 9][cell % 9].object_id.to_s
		puts "Spalte: Object_id " << @cols[cell % 9][cell / 9].object_id.to_s
		puts "Zelle: Object_id " << @elements[cell].object_id.to_s
	end
end
