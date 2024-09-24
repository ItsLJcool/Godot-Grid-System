@tool

extends "res://Scripts/BaseObject.gd"

class_name ButtonCustom

signal on_button_push(pushed:bool)

@export var ButtonNormal:Texture
@export var ButtonPushed:Texture

@onready var ButtonSpr:Sprite2D = $ButtonSpr

var pushed:bool = false:
	set(value):
		pushed = value;
		on_button_push.emit(pushed)
		if ButtonSpr:
			ButtonSpr.texture = ButtonNormal if !pushed else ButtonPushed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	pass

func on_object_move(directon:Vector2, object:BaseObject):
	if object.GRID_POSITION == GRID_POSITION:
		pushed = true
		return
	else:
		pushed = false
	for _object in get_all(get_tree().root):
		if _object == self:
			continue
		if _object.GRID_POSITION == GRID_POSITION:
			pushed = true
			return
		else:
			pushed = false
