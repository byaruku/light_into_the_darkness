class_name SpawnArea
extends Area2D

@export var objects : Array[Node2D] = []
@export var min_distance := 100

@onready var collision_polygon := $CollisionPolygon2D

var polygon : PackedVector2Array = PackedVector2Array()
var min_x : float
var max_x : float
var min_y : float
var max_y : float

var spawn_positions : Array[Vector2]= []


func spawn_objects() -> void:
	if objects.size() == 0:
		return
	
	clear_spawn_positions()
	
	polygon = collision_polygon.polygon
	
	get_max_and_min_from_polygron()
	
	for object in objects:
		var is_area_2d := object is Area2D
		var spawn_position : Vector2 = find_valid_position(is_area_2d)
		
		spawn_positions.append(spawn_position)
		
		object.position = spawn_position
	
	await get_tree().process_frame


func find_valid_position(is_area_2d: bool) -> Variant:
	var attempt := 0
	
	var distance := min_distance
	while true:
		attempt += 1
		if attempt % 10 == 0 and distance != 0:
			distance -= 1
			
		var candiate := get_random_point_in_polygon()
		
		if is_area_2d:
			if is_position_blocked(candiate):
				continue
		
		if spawn_positions.size() == 0:
			return candiate
		
		for spawn_position in spawn_positions:
			if candiate.distance_to(spawn_position) >= distance:
				return candiate
	
	return Vector2.ZERO


func is_position_blocked(pos: Vector2) -> bool:
	var shape := CircleShape2D.new()
	shape.radius = 25
	
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0.0, to_global(pos))
	query.collision_mask = 1
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var results := get_world_2d().direct_space_state.intersect_shape(query)
	
	return not results.is_empty()


func get_max_and_min_from_polygron() -> void:
	min_x = polygon[0].x
	max_x = polygon[0].x
	min_y = polygon[0].y
	max_y = polygon[0].y
	
	for point in polygon:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)


func get_random_point_in_polygon() -> Vector2:
	while true:
		var random_point := Vector2(randf_range(min_x, max_x), randf_range(min_y, max_y))
		
		if Geometry2D.is_point_in_polygon(random_point, polygon):
			return random_point
	
	return Vector2.ZERO


func clear_spawn_positions() -> void:
	spawn_positions.clear()
