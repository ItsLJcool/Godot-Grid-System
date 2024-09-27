@tool

# Idk how I can implement this properly, but it should be based off player movement
# if player moves, then it will move any item on Conveyer by a tile its facing, no more, no less

extends "res://Scripts/BaseObject.gd"

class_name Conveyer

enum Direction {
	LEFT = 0,
	DOWN = 1,
	UP = 2,
	RIGHT = 3,
}

@onready var ConveyerSpr:AnimatedSprite2D = $Spr
@onready var delay:Timer = $MoveObjDelay

func on_color_type_change(value):
	super(value)
	node_shader_to_color(ConveyerSpr, COLOR_VALUES.get(color_type_to_string(value)))

@export var CONVEYER_DIRECTION:Direction = Direction.RIGHT:
	set(value):
		CONVEYER_DIRECTION = value
		if ConveyerSpr:
			dir_booster()

func dir_booster():
	match CONVEYER_DIRECTION:
		Direction.LEFT:
			ConveyerSpr.flip_h = true
			ConveyerSpr.flip_v = false
			ConveyerSpr.play("horizontal")
		Direction.DOWN:
			ConveyerSpr.flip_h = false
			ConveyerSpr.flip_v = true
			ConveyerSpr.play("vertical")
		Direction.UP:
			ConveyerSpr.flip_h = false
			ConveyerSpr.flip_v = false
			ConveyerSpr.play("vertical")
		Direction.RIGHT:
			ConveyerSpr.flip_h = false
			ConveyerSpr.flip_v = false
			ConveyerSpr.play("horizontal")

func dir_to_vector(dir:Direction = CONVEYER_DIRECTION):
	match CONVEYER_DIRECTION:
		Direction.LEFT:
			return Vector2.LEFT
		Direction.DOWN:
			return Vector2.DOWN
		Direction.UP:
			return Vector2.UP
		Direction.RIGHT:
			return Vector2.RIGHT


func _ready() -> void:
	super()
	OBJECT_TYPE = ObjectType.PASSABLE
	dir_booster()

func _process(delta: float) -> void:
	super(delta)
	
func on_object_move(directon:Vector2, properties:Array, object:BaseObject):
	if object.GRID_POSITION == GRID_POSITION:
		var _nextPos = dir_to_vector()
		object.move(_nextPos)
		#object.update_position_target.x -= _nextPos.x*object.tile_size.x
		#object.update_position_target.y -= _nextPos.y*object.tile_size.y
		#await get_tree().create_timer(delay.wait_time).timeout
		#object.update_position_target = object.target_position
