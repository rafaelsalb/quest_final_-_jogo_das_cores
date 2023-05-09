extends Node


enum {RED, YELLOW, BLUE, ORANGE, PURPLE, GREEN, WHITE, BLACK}

const COLORS = [
	Color(1.0, 0.0, 0.0),
	Color(1.0, 1.0, 0.0),
	Color(0.0, 0.0, 1.0),
	Color(1.0, 0.5, 0.0),
	Color(0.5, 0.0, 0.5),
	Color(0.0, 1.0, 0.0),
	Color(1.0, 1.0, 1.0),
	Color(0.0, 0.0, 0.0)
]

const COLOR_NAMES = ["RED", "YELLOW", "BLUE", "ORANGE", "PURPLE", "GREEN", "WHITE", "BLACK"] # Indexes come from enum

const NAMES_COLORS = {
	"Red": 		RED,
	"Yellow": 	YELLOW,
	"Blue": 	BLUE,
	"Orange": 	ORANGE,
	"Purple": 	PURPLE,
	"Green": 	GREEN,
	"White": 	WHITE,
	"Black": 	BLACK
}


const NAME_TO_Color = {
	RED: 	Color(1.0, 0.0, 0.0),
	YELLOW: Color(1.0, 1.0, 0.0),
	BLUE: 	Color(0.0, 0.0, 1.0),
	ORANGE: Color(1.0, 0.5, 0.0),
	PURPLE: Color(0.5, 0.0, 0.5),
	GREEN: 	Color(0.0, 1.0, 0.0),
	WHITE: 	Color(1.0, 1.0, 1.0),
	BLACK: 	Color(0.0, 0.0, 0.0)
}

class PColors:
	var name: int
	var color: Color
	
	func _init(name_i):
		name = name_i
		color = COLORS[name_i]
	
	func add(c_i):
		if self.name == WHITE or c_i.name == WHITE:
			return c_i
		elif self.name == BLACK or c_i.name == BLACK:
			return PColors.new(BLACK)
		elif self.name == RED:
			if c_i.name == BLUE:
				return PColors.new(PURPLE)
			elif c_i.name == YELLOW:
				return PColors.new(ORANGE)
			return self
		elif self.name == BLUE:
			if c_i.name == RED:
				return PColors.new(PURPLE)
			elif c_i.name == YELLOW:
				return PColors.new(GREEN)
			return self
		elif self.name == YELLOW:
			if c_i.name == RED:
				return PColors.new(ORANGE)
			elif c_i.name == BLUE:
				return PColors.new(GREEN)
			return self
		else:
			return self
