@tool

extends "res://Scripts/BaseObject.gd"

class_name Door

enum DoorType {
	OPENED,
	CLOSED,
	LOCKED
}

@onready var DoorSpr:Sprite2D = $DoorSpr

func on_color_type_change(value):
	super(value)
	node_shader_to_color(DoorSpr, COLOR_VALUES.get(color_type_to_string()))

@export var ClosedTexture:Texture
@export var OpenedTexture:Texture
@export var LockedTexture:Texture

@export var ButtonReference:ButtonCustom

@export var DOOR_STATE:DoorType = DoorType.CLOSED:
	set(value):
		DOOR_STATE = value
		if DoorSpr:
			match DOOR_STATE:
				DoorType.OPENED:
					OBJECT_TYPE = ObjectType.PASSABLE
					DoorSpr.texture = OpenedTexture
				DoorType.LOCKED:
					OBJECT_TYPE = ObjectType.IMMOVABLE
					DoorSpr.texture = LockedTexture
				_:
					OBJECT_TYPE = ObjectType.IMMOVABLE
					DoorSpr.texture = ClosedTexture

func _ready() -> void:
	node_shader_to_color(DoorSpr, COLOR_VALUES.get(color_type_to_string()))
	super()
	if ButtonReference:
		ButtonReference.connect("on_button_push", on_button_push)

func _process(delta: float) -> void:
	super(delta)


func on_button_push(pushed:bool):
	if pushed:
		if DOOR_STATE == DoorType.CLOSED:
			DOOR_STATE = DoorType.OPENED
	else:
		if DOOR_STATE == DoorType.OPENED:
			DOOR_STATE = DoorType.CLOSED
