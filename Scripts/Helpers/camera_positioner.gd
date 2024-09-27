@tool

extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if BaseObject._instanced_tile_layer != null:
		var tile_size = BaseObject._instanced_tile_layer.tile_set.tile_size
		var new_x = round(position.x / tile_size.x) * tile_size.x
		var new_y = round(position.y / tile_size.y) * tile_size.y
		position = Vector2(new_x, new_y)
