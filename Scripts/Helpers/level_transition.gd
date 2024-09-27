@tool

extends Node2D

var _fallback:String = "res://Levels/Template.tscn"

var path_string:String = "res://Levels/%s/%s.tscn"
@export var LevelFileName:String = ""
@export var NextLevel:String = "Template"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if BaseObject._instanced_tile_layer != null:
		var tile_size = BaseObject._instanced_tile_layer.tile_set.tile_size
		var new_x = round(position.x / tile_size.x) * tile_size.x
		var new_y = round(position.y / tile_size.y) * tile_size.y
		position = Vector2(new_x, new_y)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		print("Do transition here")
		$TransitionDelay.start()


func _on_transition_delay_timeout() -> void:
	var pathString = path_string % [LevelFileName, NextLevel]
	var new_scene:PackedScene = load(pathString)
	
	if new_scene != null:
		get_tree().change_scene_to_packed(new_scene)
		return
	
	new_scene = load(_fallback)
	if new_scene != null:
		get_tree().change_scene_to_packed(new_scene)
	
