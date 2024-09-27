@tool

extends "res://Scripts/BaseObject.gd"

class_name Player

@export var Yellow:Texture
@export var Cyan:Texture
@export var Red:Texture
@export var Pink:Texture

@onready var PlayerCat:Sprite2D = $Cat

static var CURRENT_COLOR_TYPE:ColorType = ColorType.Yellow

func on_color_type_change(value):
	super(value)
	if Yellow == null or Cyan == null or Red == null or Pink == null or PlayerCat == null:
		return
	match value:
		ColorType.Cyan:
			PlayerCat.texture = Cyan
		ColorType.Red:
			PlayerCat.texture = Red
		ColorType.Pink:
			PlayerCat.texture = Pink
		ColorType.Yellow:
			PlayerCat.texture = Yellow

var FLIPPED:bool = false:
	set(value):
		if PlayerCat.flip_h != value:
			FLIPPED = value
		PlayerCat.flip_h = FLIPPED
#
@export var MOVE_DIRECTION_ON_START:Vector2 = Vector2.ZERO

static func find_player(node):
	if node is Player:
		return node
	for child in node.get_children():
		var result = Player.find_player(child)
		if result:
			return result
	return null
	
static func get_all_players(node):
	var data:Array = [];
	if node is BaseObject:
		data.push_back(node)
	for child in node.get_children():
		for n in get_all_players(child):
			data.push_back(n)
	return data;

static var CAN_INPUT:bool = false;

func _ready() -> void:
	super()
	$NewScene_InputDelay.start()
	$NewScene_MoveDelay.start()

func _process(delta: float) -> void:
	super(delta)
	if Engine.is_editor_hint():
		return
	
	if !CAN_INPUT or Player.CURRENT_COLOR_TYPE != COLOR_TYPE:
		return
	
	if (Input.is_action_just_pressed(input_names[0])
		or Input.is_action_just_pressed(input_names[1])
		or Input.is_action_just_pressed(input_names[2])
		or Input.is_action_just_pressed(input_names[3])):
			Global.force_to_target.emit()
			var dir:Vector2 = get_direction_from_input();
			Global.before_player_move.emit(dir, self)
			move(dir)
			Global.after_player_move.emit(dir, self)

func get_allow_walk(data):
	return data.get_custom_data("ColorType") == COLOR_TYPE or data.get_custom_data("ColorType") == ColorType.White

var input_names:Array = [
	"Player_Right", "Player_Left", "Player_Down", "Player_Up"
]

func get_direction_from_input() -> Vector2:
	if Input.is_action_just_pressed(input_names[0]):
		return Vector2.RIGHT
	elif Input.is_action_just_pressed(input_names[1]):
		return Vector2.LEFT
	elif Input.is_action_just_pressed(input_names[2]):
		return Vector2.DOWN
	elif Input.is_action_just_pressed(input_names[3]):
		return Vector2.UP
	return Vector2.ZERO


func move(direction:Vector2, properties:Array = _properties_default):
	super(direction, properties)
	if direction.x != 0:
		FLIPPED = true if direction.x < 0 else false

func _on_new_scene_input_delay_timeout() -> void:
	CAN_INPUT = true

func _on_new_scene_move_delay_timeout() -> void:
	if MOVE_DIRECTION_ON_START != Vector2.ZERO:
		move(MOVE_DIRECTION_ON_START)


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
