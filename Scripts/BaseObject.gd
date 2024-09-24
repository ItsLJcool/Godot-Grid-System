@tool

extends Node2D

class_name BaseObject

@export var move_speed:int = 15

enum ObjectType {
	IMMOVABLE,
	MOVABLE,
	PASSABLE,
}
func type_to_string(type:ObjectType = current_object_type):
	return ObjectType.keys()[type].capitalize()

@export var OBJECT_TYPE:ObjectType = ObjectType.MOVABLE:
	set(value):
		OBJECT_TYPE = value;
		current_object_type = value;
var current_object_type:ObjectType = OBJECT_TYPE;

# Gets all scenes or "nodes" of the class type.
func get_all(node):
	var data:Array = [];
	if node is BaseObject:
		data.push_back(node)
	for child in node.get_children():
		for n in get_all(child):
			data.push_back(n)
	return data;

@export var TileLayer:TileMapLayer

var tile_size:Vector2i:
	get:
		if !TileLayer:
			return Vector2i(128, 128)
		return TileLayer.tile_set.tile_size

var target_position:Vector2 = Vector2.ZERO:
	set(value):
		target_position = value;
		if TileLayer:
			GRID_POSITION = TileLayer.local_to_map(TileLayer.to_local(target_position))
	get:
		if TileLayer:
			GRID_POSITION = TileLayer.local_to_map(TileLayer.to_local(target_position))
		return target_position
		
var prev_target_position:Vector2 = Vector2.ZERO
@export var _last_direction:Vector2 = Vector2.ZERO

var GRID_POSITION:Vector2:
	get:
		if TileLayer:
			GRID_POSITION = TileLayer.local_to_map(TileLayer.to_local(target_position))
			return GRID_POSITION;
		else:
			return GRID_POSITION;

func _ready() -> void:
	Global.connect("on_object_move", on_object_move)
	Global.connect("force_to_target", force_to_target)
	target_position = position
	prev_target_position = target_position

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		var new_x = round(position.x / tile_size.x) * tile_size.x
		var new_y = round(position.y / tile_size.y) * tile_size.y
		target_position = Vector2(new_x, new_y)
		prev_target_position = target_position
		position = target_position
		return
	
	position = move_towards_target(position, target_position, move_speed)

func move_towards_target(current_position: Vector2, target_position: Vector2, speed: float) -> Vector2:
	var direction = (target_position - current_position).normalized()
	var new_position = current_position + direction * speed
	if current_position.distance_to(target_position) < speed:
		new_position = target_position
	return new_position

enum MoveProperties {
	ALLOW_SLIDING,
	CHECK_TILE
}

var _properties_default:Array = [
	MoveProperties.ALLOW_SLIDING,
	MoveProperties.CHECK_TILE
];

# indexes of all moves made, will cap it at some point
var buffer_moves:Array = []

func do_step_move(idx:int):
	pass

func move(direction:Vector2, properties:Array = _properties_default):
	_last_direction = direction
	prev_target_position = target_position
	target_position.x += direction.x * tile_size.x
	target_position.y += direction.y * tile_size.y
	
	Global.on_object_move.emit(direction, self)
	
	if properties.has(MoveProperties.CHECK_TILE):
		tile_handle(direction, properties)
		
	#Global.on_object_move.emit(direction, self)

var moving_on_ice:bool = false
func tile_handle(direction:Vector2, properties:Array):
	if not TileLayer:
		return
	
	var customData = TileLayer.get_cell_tile_data(GRID_POSITION)
	var next_customData = TileLayer.get_cell_tile_data(GRID_POSITION + direction)
	
	if customData:
		var allowed_walk = get_allow_walk(customData)
		if not allowed_walk:
			current_object_type = ObjectType.IMMOVABLE
			move(-direction, [MoveProperties.CHECK_TILE])
			return
		
		if customData.get_custom_data("ice") and properties.has(MoveProperties.ALLOW_SLIDING):
			# Idea:
			# We calculate the amount of direction here, instead of having the game do other calculations
			# since it will perserve integrety of data... or smth idk not smart
			# simple terms: fixes ice physics issues, hopefully.
			# Future me: it did, but it introduced something I didn't expect, but can be put as a puzzle element now
			# Further Future me: I re did all of that so not sure if that puzzle element will be a thing now :sob:
			var no_sliding = properties.filter(func(item): return item != MoveProperties.ALLOW_SLIDING)
			ice_move(do_ice_calculation(direction), 0, no_sliding)
			ice_move(do_ice_calculation(direction), 1, no_sliding)
			ice_mode = false
			
var ice_mode:bool = false
func ice_move(direction:Vector2, pos:int, properties:Array):
	ice_mode = true
	var all_objects = get_all(get_tree().root)
	var dir_x:int = direction.x if pos == 0 else direction.y
	var vec_left_right:Array = [Vector2.LEFT, Vector2.RIGHT] if pos == 0 else [Vector2.UP, Vector2.DOWN]
	var dir = vec_left_right[0] if dir_x < 0 else vec_left_right[1]
	_last_direction = dir
	for idx in abs(dir_x):
		prev_target_position = target_position
		target_position.x += dir.x * tile_size.x
		target_position.y += dir.y * tile_size.y
		tile_handle(dir, properties)
		var _break:bool = false
		for object in all_objects:
			if object == self:
				continue
			if object.GRID_POSITION == GRID_POSITION:
				if object.current_object_type != ObjectType.IMMOVABLE and object.current_object_type != ObjectType.PASSABLE:
					print("ice move")
					object.move(dir)
					object.move(Vector2.ZERO)
					_break = true
					break;
		if _break:
			break;

func get_allow_walk(data):
		return not data.get_custom_data("wall")

func do_ice_calculation(additional_direction:Vector2) -> Vector2:
	var final_calculation:Vector2 = Vector2.ZERO;
	
	if not TileLayer: # just to be safe
		return final_calculation
	
	var grid_calc = GRID_POSITION
	var ice_customData = TileLayer.get_cell_tile_data(GRID_POSITION)
	var tempIDX:int = 0
	while((ice_customData and ice_customData.get_custom_data("ice"))):
		final_calculation += additional_direction
		grid_calc = GRID_POSITION + final_calculation
		ice_customData = TileLayer.get_cell_tile_data(GRID_POSITION + final_calculation)
	return final_calculation

func force_to_target():
	position = target_position

func on_object_move(directon:Vector2, object:BaseObject):
	if object == self:
		return
	if current_object_type == ObjectType.IMMOVABLE:
		if object.GRID_POSITION == GRID_POSITION:
			if ice_mode:
				var no_sliding = _properties_default.filter(func(item): return item != MoveProperties.ALLOW_SLIDING)
				object.move(-directon, no_sliding)
			else:
				object.move(-directon)
	elif current_object_type == ObjectType.MOVABLE:
		if object.GRID_POSITION == GRID_POSITION:
			if ice_mode:
				var no_sliding = _properties_default.filter(func(item): return item != MoveProperties.ALLOW_SLIDING)
				move(directon, no_sliding)
			else:
				move(directon)
	
	current_object_type = OBJECT_TYPE
