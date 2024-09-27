@tool

extends "res://Scripts/BaseObject.gd"

class_name ButtonCustom

signal on_button_push(pushed:bool)

@onready var ButtonSpr:Sprite2D = $ButtonSpr

func on_color_type_change(value):
	super(value)
	node_shader_to_color(ButtonSpr, COLOR_VALUES.get(color_type_to_string(value)))

@export var ButtonNormal:Texture
@export var ButtonPushed:Texture

var pushed:bool = false:
	set(value):
		pushed = value;
		on_button_push.emit(pushed)
		if ButtonSpr:
			ButtonSpr.texture = ButtonNormal if !pushed else ButtonPushed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	Global.connect("after_player_move", after_player_move)
	OBJECT_TYPE = ObjectType.PASSABLE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	pass

func after_player_move(dir:Vector2, player:Player):
	pushed = false
	
	if player.GRID_POSITION == GRID_POSITION and player.COLOR_TYPE == COLOR_TYPE:
		pushed = true
		return
	
	for object in get_all(get_tree().root):
		if object == self:
			continue
		
		if object.GRID_POSITION == GRID_POSITION and object.COLOR_TYPE == COLOR_TYPE:
			pushed = true
			return
