@tool

extends "res://Scripts/BaseObject.gd"

class_name Conveyer

static var CAN_MOVE_ON:bool = true

enum Direction {
	LEFT = 0,
	DOWN = 1,
	UP = 2,
	RIGHT = 3,
}

@onready var ConveyerSpr:AnimatedSprite2D = $Spr

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

func force_to_target():
	super()
	#Conveyer.CAN_MOVE_ON = true
	
func on_object_move(directon:Vector2, properties:Array, object:BaseObject):
	if not Conveyer.CAN_MOVE_ON:
		return
	
	if object.GRID_POSITION == GRID_POSITION:
		object.move(dir_to_vector())
		Conveyer.CAN_MOVE_ON = false
