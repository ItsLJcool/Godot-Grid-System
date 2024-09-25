@tool

extends "res://Scripts/BaseObject.gd"

class_name Booster

@onready var BoosterSpr:AnimatedSprite2D = $BoosterSpr

func on_color_type_change(value):
	super(value)
	node_shader_to_color(BoosterSpr, COLOR_VALUES.get(color_type_to_string(value)))

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
	OBJECT_TYPE = ObjectType.PASSABLE
	dir_booster()

func _process(delta: float) -> void:
	super(delta)

func on_object_move(directon:Vector2, properties:Array, object:BaseObject):
	if object.GRID_POSITION == GRID_POSITION:
		object.move(dir_to_vector()*2)
		return
