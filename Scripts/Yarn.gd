@tool

extends "res://Scripts/BaseObject.gd"

class_name Yarn

@onready var spr:Sprite2D = $YarnSpr

func on_color_type_change(value):
	super(value)
	node_shader_to_color(spr, COLOR_VALUES.get(color_type_to_string(value)))

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
