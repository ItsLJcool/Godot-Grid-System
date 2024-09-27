extends Node

signal on_object_move(direction:Vector2, properties:Array, object:BaseObject)
signal force_to_target()
signal after_player_move(direction:Vector2,player:Player)
signal before_player_move(direction:Vector2,player:Player)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("Change_Player_Color"):
		switch_cat()
	if Input.is_action_just_pressed("UNDO"):
		for object in BaseObject.get_all(get_tree().root):
			var last_index = len(object.buffer_moves)-1
			if last_index != -1:
				var arrayItem = object.buffer_moves[last_index]
				object.move(-arrayItem, [])
				object.buffer_moves.remove_at(last_index)

func switch_cat():
		match Player.CURRENT_COLOR_TYPE:
			BaseObject.ColorType.Yellow:
				Player.CURRENT_COLOR_TYPE = BaseObject.ColorType.Cyan
			BaseObject.ColorType.Cyan:
				Player.CURRENT_COLOR_TYPE = BaseObject.ColorType.Red
			BaseObject.ColorType.Red:
				Player.CURRENT_COLOR_TYPE = BaseObject.ColorType.Pink
			BaseObject.ColorType.Pink:
				Player.CURRENT_COLOR_TYPE = BaseObject.ColorType.Yellow
		var isAvalColor:bool = false
		for player in Player.get_all_players(get_tree().root):
			if player.COLOR_TYPE == Player.CURRENT_COLOR_TYPE:
				isAvalColor = true;
				break
		if not isAvalColor:
			switch_cat()
