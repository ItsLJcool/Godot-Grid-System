@tool

extends "res://Scripts/BaseObject.gd"

class_name Booster

enum Direction {
	LEFT = 0,
	DOWN = 1,
	UP = 2,
	RIGHT = 3,
}

func dir_to_vector(dir:Direction = BOOSTER_DIRECTION):
	match BOOSTER_DIRECTION:
		Direction.LEFT:
			return Vector2.LEFT
		Direction.DOWN:
			return Vector2.DOWN
		Direction.UP:
			return Vector2.UP
		Direction.RIGHT:
			return Vector2.RIGHT

@onready var BoosterSpr:AnimatedSprite2D = $BoosterSpr

#@export var ColorType:Player.Type = Player.Type.Yellow:
	#set(value):
		#ColorType = value;
		#init_booster();

@export var BOOSTER_DIRECTION:Direction = Direction.RIGHT:
	set(value):
		BOOSTER_DIRECTION = value
		if BoosterSpr:
			dir_booster()

func dir_booster():
	match BOOSTER_DIRECTION:
		Direction.LEFT:
			BoosterSpr.rotation_degrees = 180
		Direction.DOWN:
			BoosterSpr.rotation_degrees = 90
		Direction.UP:
			BoosterSpr.rotation_degrees = -90
		Direction.RIGHT:
			BoosterSpr.rotation_degrees = 0

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)

func on_object_move(directon:Vector2, object:BaseObject):
	object.extra.wasBoosted = false
	
	if object.GRID_POSITION == GRID_POSITION and not object.extra.wasBoosted:
		object.extra.wasBoosted = true
		object.move(dir_to_vector()*2)
		return
	else:
		object.extra.wasBoosted = false
