#encoding: utf-8

# Klasse zum Darstellen von Sudokus.
class Sudoku

	# Erstellt ein Sudoku. Eingabe muss ein String von 81 kommaseparierten Zahlen als Strings sein.
	# Wenn eine Zelle leer ist, muss "0" angegeben werden. Andere mögliche Eingabe: leeres Sudoku (leerer String)
	def initialize sudoku_string
		unless sudoku_string.strip =~ /^(\d,){80}\d$/ || sudoku_string == ""
			abort "Eingabe ist kein Sudoku!"
		end

		length = 9
		
		# Initialisiert Reihen-, Spalte-, Elemente- und Blöcke-Array (Blöcke-Array beinhaltet Objekte vom Typ Block)
		@elements = Array.new length ** 2
		@candidates = Array.new length ** 2

		# Fügt die Zahlen in das Sudoku ein
		i = 0
		sudoku_string.strip.each_char do |char|
			if char == ","
				i += 1
			else
				@elements[i] = char.to_i
			end
		end

		# Falls leeres Sudoku, füge in Reihen-, Spalten- und Elemente-Array auch Nullen ein
		# (Referenzen auf dieselben Objekte wie im Blöcke-Array)
		if sudoku_string == ""
			(0...length ** 2).each do |i|
				@elements[i] = 0
			end
		end

		(0...length ** 2).each do |i|
			@candidates[i] = candidates i
		end
	end
	
	# Fügt Zahl in Zelle ein (Angabe von Zellennummer (von links nach rechts und von oben nach unten)
	def put_elem cell, neuer_wert
		@elements[cell] = neuer_wert
		# Entferne neuen Wert aus Zellen des Kandidatenarrays in selber Zeile, Spalte und selbem Block
		@candidates[cell] = []
		get_other_house_cells(cell).each do |i|
			@candidates[i].delete neuer_wert
		end

	end

	# Gibt Zahl aus Zelle aus
	def get_elem cell
		return @elements[cell]
	end

	# Prüft, ob Zelle leer ist
	def empty? cell
		return @elements[cell] == "0"
	end
	
	# Gibt Kandidatenarray aus
	def get_candidates
		return @candidates
	end

	# Funktion wird gar nicht benutzt!
	# Gibt Zellen aus, die für angegebene Zahl möglich ist
	def possible_cells number
		# mögliche Stellen
		return (0...9 ** 2).select { |i| empty?(i) && !get_row_cells[i].include?(number) && !get_col_cells[i].include?(number) && !get_block_cells[i].include?(number) }.to_a
	end

	# Gibt mögliche Zahlen für die Zelle (Angabe der Koordinaten) aus
	def candidates cell
		# Wenn Zelle nicht leer ist, gibt es keine möglichen Zahlen
		return [] unless @elements[cell] == 0

		possible_numbers = *(1..9)
		
		# Prüfe, welche Zahlen nicht möglich sind
		row_cells = get_row_cells (get_row cell)
		col_cells = get_col_cells (get_col cell)
		block_cells = get_block_cells (get_block cell)
		get_other_house_cells(cell).each do |i|
			a = @elements[i]
			possible_numbers.delete a unless a == 0
		end
		return possible_numbers
	end
	private :candidates

	def get_block cell
		return cell / 27 * 3 + cell % 9 / 3
	end

	def get_row cell
		return cell / 9
	end

	def get_col cell
		return cell % 9
	end

	# Gibt die letzte mögliche Zahl für eine Zelle aus
	def naked_single cell
		return @candidates[cell].length == 1 ? @candidates[cell][0] : false
	end

	# Gibt Häuserzellen aus
	def get_house_cells cell
		house_cells = get_row_cells(get_row cell) + get_col_cells(get_col cell) + get_block_cells(get_block cell)
		return house_cells.uniq!
	end

	# Gibt Häuserzellen aus (ohne angegebene)
	def get_other_house_cells cell
		return get_house_cells(cell) - [cell]
	end

	# Gibt Zellen der Reihe aus
	def get_row_cells row
		return (row * 9...row * 9 + 9).to_a
	end

	# Gibt Zellen der Reihe (ohne angegebene) aus
	def get_other_row_cells cell
		return get_row_cells(get_row cell) - [cell]
	end

	# Gibt Zellen der Spalte aus
	def get_col_cells col
		return (col...9 ** 2).step(9).to_a
	end

	# Gibt Zellen der Spalte (ohne angegebene) aus
	def get_other_col_cells cell
		return get_col_cells(get_col cell) - [cell]
	end

	# Gibt Zellen des Blocks aus
	def get_block_cells block
		block_cells = []
		(block / 3 * 3...block / 3 * 3 + 3).each do |r|
			(block % 3 * 3...block % 3 * 3 + 3).each do |c|
				block_cells << r * 9 + c
			end
		end
	return block_cells

	end

	# Gibt Zellen des Blocks (ohne angegebene) aus
	def get_other_block_cells cell
		block = get_block cell
		first_cell = cell / 27 * 27
		return (first_cell...first_cell + 27).select { |r| block == r / 27 * 3 + r % 9 / 3 }.to_a - [cell]
	end

	# Hidden Single
	def hidden_single cell
		#a = false
		@candidates[cell].each do |candidate|
			#warum diese bedingung nicht leer und beinhaltet kandidat?
			if get_other_row_cells(cell).select { |i| !@candidates[i].empty? && @candidates[i].include?(candidate) }.empty? \
				|| get_other_col_cells(cell).select { |i| !@candidates[i].empty? && @candidates[i].include?(candidate) }.empty? \
				|| get_other_block_cells(cell).select { |i| !@candidates[i].empty? && @candidates[i].include?(candidate) }.empty?
				
				return candidate
			end
		end
		return false
	end

	# Locked Candidates Type 1
	def locked_candidates_1_from_block block, number
		block_cells = get_block_cells block
		block_cells_with_number = block_cells.select { |i| @candidates[i].include?(number) }
		
		return_bool = false

		if block_cells_with_number.empty?
			return return_bool
		end

		block_cell_rows = block_cells_with_number.map { |i| i / 9 }
		
		only_in_row = block_cell_rows.count(block_cell_rows[0]) == block_cell_rows.length ? true : false

		if only_in_row
			number_of_deleted_items = 0
			get_other_row_cells(block_cells_with_number[0]).select { |i| !block_cells_with_number.include?(i) }.each do |i|
				deleted_item = @candidates[i].delete number
				number_of_deleted_items += 1 if !deleted_item.nil?
			end
			return_bool = true if number_of_deleted_items > 0
		end

		block_cell_cols = block_cells_with_number.map { |i| i % 9 }

		only_in_col = block_cell_cols.count(block_cell_cols[0]) == block_cell_cols.length ? true : false
		
		if only_in_col
			number_of_deleted_items = 0
			get_other_col_cells(block_cells_with_number[0]).select { |i| !block_cells_with_number.include?(i) }.each do |i|
				deleted_item = @candidates[i].delete number
				number_of_deleted_items += 1 if !deleted_item.nil?
			end
			return_bool = true if number_of_deleted_items > 0
		end
		
		return return_bool
	end

	# Locked Candidates Type 2
	def locked_candidates_2_from_row row, number
		row_cells = get_row_cells row
		row_cells_with_number = row_cells.select { |i| @candidates[i].include?(number) }
		if row_cells_with_number.empty?
			return false
		end

		row_cell_blocks = row_cells_with_number.map { |i| get_block i }

		only_in_block = row_cell_blocks.count(row_cell_blocks[0]) == row_cell_blocks.length ? true : false

		if only_in_block
			number_of_deleted_items = 0
			get_block_cells(row_cell_blocks[0]).select { |i| !row_cells_with_number.include?(i) }.each do |i|
				deleted_item = @candidates[i].delete number
				number_of_deleted_items += 1 if !deleted_item.nil?
			end
			return true if number_of_deleted_items > 0
		end

		return false	
	end

	# Locked Candidates Type 2 aus Spalte
	def locked_candidates_2_from_col col, number
		col_cells = get_col_cells col
		col_cells_with_number = col_cells.select { |i| @candidates[i].include?(number) }
		if col_cells_with_number.empty?
			return false
		end

		col_cell_blocks = col_cells_with_number.map { |i| get_block i }

		only_in_block = col_cell_blocks.count(col_cell_blocks[0]) == col_cell_blocks.length ? true : false

		if only_in_block
			number_of_deleted_items = 0
			get_block_cells(col_cell_blocks[0]).select { |i| !col_cells_with_number.include?(i) }.each do |i|
				deleted_item = @candidates[i].delete number
				number_of_deleted_items += 1 if !deleted_item.nil?
			end
			return true if number_of_deleted_items > 0
		end

		return false
	end

	# Hidden Tuple aus Block
	def hidden_tuple_from_block block, type
		hidden_tuple get_block_cells(block), type
	end

	# Hidden Tuple aus Reihe
	def hidden_tuple_from_row row, type
		hidden_tuple get_row_cells(row), type
	end

	# Hidden Tuple aus Spalte
	def hidden_tuple_from_col col, type
		hidden_tuple get_col_cells(col), type
	end

	# Funktion für die Berechnung eines Hidden Tuple
	def hidden_tuple cells, type
		number_of_filled_cells = cells.select { |c| @candidates[c].empty? }.length
		combinations = cells.combination(type).select { |c| c.select { |i| !@candidates[i].empty? }.length == type }

		combinations.each do |i|
			union = Array.new
			cells.select { |j| !i.include?(j) && !@candidates[j].empty? }.each do |k|
				union |= @candidates[k]
			end
			
			if union.length == 9 - type - number_of_filled_cells
				i.each do |j|
					@candidates[j] -= union
					#puts "kandidaten für " << j.to_s << ": " << @candidates[j].to_s
				end
				return true
			end
			
		end
		return false
	end

	private :hidden_tuple

	def solve
		# 1 Naked Singles
		(0...9 ** 2).each do |i|
			ns = naked_single i
			if ns != false
				put_elem i, ns
				puts "Naked Single in Zelle " << i.to_s << ", Zahl " << ns.to_s
			end
		end

		# 2: Hidden Singles
		(0...9 ** 2).each do |i|
			hs = hidden_single i
			if hs != false
				put_elem i, hs
				puts "Hidden Single in Zelle " << i.to_s << ", Zahl " << hs.to_s
			end
		end
		
		# 3: Locked Candidates Type 1
		(0...9).each do |b|
			(1..9).each do |i|
				lc1 = locked_candidates_1_from_block b, i
				if lc1 != false
					puts "Locked Candidates Type 1 in Block " << b.to_s << ", Zahl " << i.to_s
				end
			end
		end
		
		# 4: Locked Candidates Type 2: Reihen
		(0...9).each do |r|
			(1..9).each do |i|
				lc2 = locked_candidates_2_from_row r, i
				if lc2 != false
					puts "Locked Candidates Type 2 in Reihe " << r.to_s << ", Zahl " << i.to_s
				end
			end
		end

		# 5: Locked Candidates Type 2: Spalten
		(0...9).each do |c|
			(1..9).each do |i|
				lc2 = locked_candidates_2_from_col c, i
				if lc2 != false
					puts "Locked Candidates Type 2 in Spalte " << c.to_s << ", Zahl " << i.to_s
				end
			end
		end

		# 6 Hidden Tuples
		(0...9).each do |i|
			(2..4).each do |j|
				ht = hidden_tuple_from_block i, j
				if ht != false
					puts "Hidden " << j.to_s << "-Tuple in Block " << i.to_s
				end
				ht = hidden_tuple_from_row i, j
				if ht != false
					puts "Hidden " << j.to_s << "-Tuple in Reihe " << i.to_s
				end
				ht = hidden_tuple_from_col i, j
				if ht != false
					puts "Hidden " << j.to_s << "-Tuple in Block " << i.to_s
				end
			end
		end
	end

	# Gibt Sudoku aus
	def get_sudoku
		puts @elements.to_s
	end
end
