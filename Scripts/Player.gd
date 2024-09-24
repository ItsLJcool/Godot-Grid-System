@tool

extends "res://Scripts/BaseObject.gd"

class_name Player

static func find_player(node):
	if node is Player:
		return node
	for child in node.get_children():
		var result = Player.find_player(child)
		if result:
			return result
	return null

static var CAN_INPUT:bool = true;

func _ready() -> void:
	super()
	pass # Replace with function body.


func _process(delta: float) -> void:
	super(delta)
	if Engine.is_editor_hint():
		return
	
	if !CAN_INPUT:
		return
	
	if (Input.is_action_just_pressed(input_names[0])
		or Input.is_action_just_pressed(input_names[1])
		or Input.is_action_just_pressed(input_names[2])
		or Input.is_action_just_pressed(input_names[3])):
			Global.force_to_target.emit()
			var dir:Vector2 = get_direction_from_input();
			move(dir)
	

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
	
