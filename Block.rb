#encoding: UTF-8

# Klasse zum Darstellen von 3×3-Blöcken
class Block

	# Erstellt einen Block. Nicht vorhandene Argumente werden mit Nullen (d. h. nicht gesetzt) aufgefüllt
	def initialize *args

		length = 3
		abort "Zu viele Argumente!" if args.length > length ** 2
	
		# Initialisiert Reihen-, Spalten- und Elemente-Array
		@rows = init_2dim_array length
		@cols = init_2dim_array length
		@elements = Array.new length ** 2

		# Fügt Elemente in Reihen-, Spalten- und Elemente-Array ein.
		# Elemente in Reihen-, Spalten und Elemente-Array zeigen auf dasselbe Objekt, damit
		# Veränderungen in dem einen Array sich auch auf die anderen auswirken.
		(0...args.length).each do |i|
			arg = args[i].to_s
			@elements[i] = arg
			@rows[i / length][i % length] = arg
			@cols[i % length][i / length] = arg
		end
		(args.length...length ** 2).each do |i|
			value = '0'
			@elements[i] = value
			@rows[i / length][i % length] = value
			@cols[i % length][i / length] = value
		end

	end
	
	# Erstellt ein zweidimensionales quadratisches Array von Länge length
	def init_2dim_array length
		block = Array.new length
		block.each_index do |i|
			block[i] = Array.new length
		end
		return block
	end

	# Gibt ein Element aus
	def get_elem reihe, spalte
		return @rows[reihe][spalte]
	end

	# Gibt ein Element aus
	def elem reihe, spalte
		get_elem reihe, spalte
	end

	# Fügt ein Element ein
	def put_elem reihe, spalte, neuer_wert
		@rows[reihe][spalte].replace neuer_wert.to_s
	end

	# Gibt eine Reihe aus
	def row row
		return @rows[row]
	end

	# Gibt eine Spalte aus
	def col col
		return @cols[col]
	end

	# Prüft, ob eine Zahl vorkommt
	def include? number
		return @elements.include? number.to_s
	end

	# Gibt Anzahl der freien Zellen aus
	def count_free_cells
		return @elements.grep('0').size
	end

	# Gibt Anzahl der belegten Zellen aus
	def size
		return @elements.select { |v| v != "0" }.size
	end
	
	# Testfunktion
	def get_object_id
		length = 3
		(0...length ** 2).each do |i|
			puts @rows[i / length][i % length].object_id
			puts @cols[i % length][i / length].object_id
			puts @elements[i].object_id
		end
	end

	private :init_2dim_array
end

