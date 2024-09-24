@tool

extends "res://Scripts/BaseObject.gd"

class_name Door

enum DoorType {
	OPENED,
	CLOSED,
	LOCKED
}

@export var ClosedTexture:Texture
@export var OpenedTexture:Texture
@export var LockedTexture:Texture

@export var ButtonReference:ButtonCustom

@onready var DoorSpr:Sprite2D = $DoorSpr

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
