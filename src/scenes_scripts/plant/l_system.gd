extends Node

# L-System scene generator
# Cmpt 461 Final Project
# Allen Pike, apike@sfu.ca

# This program takes an L-System definition, and outputs a .pbrt scene file of that model.
# The .pbrt scene file can be included into a master scene file and rendered with the
# raytracer pbrt.
 
## Todo: 
# Implement command-line arguments.
# Make stochastic tree.
# Make field of stochastic trees.

# Default values.

#var n = 4
#var delta = 22
#var axiom = 'F'
#var productions = {}

#var cylRadius = 0.1 # Initial radius of segments.
var leafRadius = 0.05 # Radius of leaf segments.
var shrinkFactor = 1.4 # Shrinking effect of branching.


var bark = preload("res://src/materials/wood.tres")
var leaf = preload("res://src/materials/leaf.tres")
var flower = preload("res://src/materials/leaf.tres")

# L-System definitions.
# Comment out one of these to have it generate that L-System.

#p10-a: Koch curve
#n = 4
#delta = 90.0
#axiom = "F-F-F-F"
#productions = {'F': 'FF-F-F-F-F-F+F'}

#p10-4: Koch curve
#n = 4
#delta = 90.0
#axiom = "F-F-F-F"
#productions = {'F': 'F-F+F-F-F'}

#p12-a: Hexagonal Gosper Curve
#n = 4
#delta = 60.0
#axiom = "F"
#productions = {'F': 'F+f++f-F--FF-f+', 'f' : '-F+ff++f+F--F-f'}

#p12-a: Sierpinski gasket
#n = 6
#delta = 60.0
#axiom = "f"
#productions = {'F': 'f+F+f', 'f' : 'F-f-F'}

#p20: 3D Hilbert curve
#n = 3
#delta = 90.0
#axiom = "A"
#productions = {'A': 'B-F+CFC+F-D&F^D-F+&&CFC+F+B//', 
#				'B': 'A&F^CFB^F^D^^-F-D^|F^B|FC^F^A//',
#				'C': '|D^|F^B-F+C^F^A&&FA&F^C+F+B^F^D//',
#				'D': '|CFB-F+B|FA&F^A&&FB-F+B|FC//'}

#p25-a
#n = 5
#delta = 25.7
#axiom = "F"
#productions = {'F': 'F[+F]F[-F]F'}

#p25-c
#n = 4
#delta = 22.5
#axiom = "F"
#productions = {'F': 'FF-[-F+F+F]+[+F-F-F]'}

#p25-d
#n = 7
#delta = 20.0
#axiom = "X"
#productions = {'X': 'F[+X]F[-X]+X', 'F': 'FF'}

#p27 - flower
#n = 5
#delta = 18
#bark = leaf
#leafRadius = 0.15 # Radius of leaf segments.
#flowerColors =  ['[4.0 0.1 2.0]', '[0.1 2.0 4.0]', '[4.0 1.0 0.1]', '[4.0 5.0 2.0]', '[1.0 1.0 3.0]']
#flower = 'Material "matte" "color Kd" ' + flowerColors[random.randint(0, len(flowerColors)-1)]
#axiom = 'P'
#cylRadius = 0.3 # Initial radius of segments.
#productions = {	'P': 'I + [P + O] - - // [--L] I [++L] - [P O] ++ PO',
#				'I': 'F S [// && L] [// ^^ L] F S',
#				'S': [(33, 'S [// && L] [// ^^ L] F S'), (33, 'S F S'), (34, 'S')],  
#				'L': '[`{+f-ff-f+ | +f-ff-f}]',
#				'O': '[&&& D `/ W //// W //// W //// W //// W]',
#				'D': 'FF',
#				'W': '[`^F] [<&&&& -f+f | -f+f>]'
#			}

			
#26: bush/tree
#n = 7
#delta = 22.5
#cylRadius = 1.0
#axiom = "A"
#productions = {'A': '[&FL!A]/////`[&FL!A]///////`[&FL!A]', 
#					'F': 'S ///// F',
#					'S': 'F L',
#					'L': '[```^^{-f+f+f-|-f+f+f}]'}

#26: tree with leaves
var n = 7
var delta = 22.5
var cylRadius = 1.0
var axiom = "A"
var productions = {'A': '[&FLA]/////[&FLA]///////`[&FLA]', 
					'F': 'S ///// F',
					'S': 'F',
					'L': '[Q^^Q][Q\\\\Q]'}

#func _ready() -> void:
	#l_system(axiom)
					

#print('# Building L-System with %d productions and %s iterations.' % (len(productions) , n))
#print('# Initial axiom is %s.' % (axiom,))
func l_system(axiom_: String):
	var current = axiom_ # The working pattern
	var next = ""
	var replacement = ''

	for i in range(n): # For each iteration
		for sym in range(len(current)): # For each symbol in the current pattern
			#print '# %s: ' % (current[sym],),
			var found = 0
			for search in productions.keys(): # For each production
				var replace = productions[search]
				if (current[sym] == search): # Found a symbol to replace
					if (typeof(replace) == TYPE_ARRAY): # Select an option based on chance
						var choice = randi_range(0, 99)
						var optionsSeeked = 0
						for chance in range(replace):
							var option = replace[chance]
							optionsSeeked = optionsSeeked + chance
							if optionsSeeked >= choice: # Found your choice
								replacement = option
								break
					else:
						replacement = replace # It's a simple string.
					next = next + replacement
					#print '%s -> %s.' % (search, replace)
					found = 1
					break
			if not found:
				#print 'copied.'
				next = next + current[sym]
		current = next # This iteration is done, pass the pattern along.
		next = ""
		print("# Iteration %d complete, having arrived at %d.\n" %[i, current])

	var system = current
	var storedRadius = cylRadius
					
	# We now have the final L-System. Interpret these rules as a turtle-drawing algorithm.

	# Initialize
	print( bark)

	var drawSize = 1.0

	for i in range(len(system)):
		if system[i] == "F" or system[i] == "f":
			print( 'Shape "cylinder" "float radius" [%d] "float zmin" [0.0] "float zmax" [%d]' % [cylRadius, drawSize])
			print( "Translate 0.0 0.0 %d" % (drawSize))
		elif system[i] == "+":
			print( "Rotate %d 0.0 1.0 0.0" % (delta))
		elif system[i] == "-":
			print( "Rotate -%d 0.0 1.0 0.0" % (delta))
		elif system[i] == "&":
			print("Rotate %d 1.0 0.0 0.0" % (delta))
		elif system[i] == "^":
			print("Rotate -%d 1.0 0.0 0.0" % (delta))
		elif system[i] == "\\":
			print("Rotate %d 0.0 0.0 1.0" % (delta))
		elif system[i] == "/":
			print("Rotate -%d 0.0 0.0 1.0" % (delta))
		elif system[i] == "|":
			print("Rotate 180 0.0 1.0 0.0")
		elif system[i] == "Q":
			print(leaf)
			print("Translate 0.0 0.0 %d" % (1.0 + cylRadius))
			
			var rot = randf_range(0, 80)
			var rx = randf_range(0, 0.5)
			var ry = randf_range(0, 0.5)
			var rz = randf_range(0, 0.5)
			
			print( 'Rotate %d %d %d %d' % [rot, rx, ry, rz])
			print( 'Shape "disk" "float radius" [%d]' % (randf_range(0.2, 0.6)))
			print( 'Rotate %d -%d -%d -%d' % [rot, rx, ry, rz])
			print( "Rotate 180 0.0 1.0 0.0")
			print( "Translate 0.0 0.0 %d" % (1.0 + cylRadius))
			print( bark)
		elif system[i] == "[": # Branch.
			cylRadius = cylRadius / shrinkFactor # Shrink.
			print( "AttributeBegin")
			print( "Translate 0.0 0.0 %d" % (-cylRadius))
		elif system[i] == "]": # Unbranch.
			cylRadius = cylRadius * shrinkFactor # Grow.
			print( "AttributeEnd")
		elif system[i] == "{" or system[i] == "<":
			storedRadius = cylRadius
			cylRadius = leafRadius
			if system[i] == "{":
				drawSize = 0.7
				print( "leaf")
			else:
				print("flower")
		elif system[i] == "}" or system[i] == ">":
			cylRadius = storedRadius
			drawSize = 1.0
			print( "bark")
		else:
			print( "# Not a drawing symbol: %d" % [(system[i])])
