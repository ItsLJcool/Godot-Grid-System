@tool

extends "res://Scripts/BaseObject.gd"

@onready var Yarn:Sprite2D = $Yarn

func on_color_type_change(value):
	super(value)
	node_shader_to_color(Yarn, COLOR_VALUES.get(color_type_to_string(value)))

func _ready() -> void:
	super()

func _process(delta: float) -> void:
	super(delta)
