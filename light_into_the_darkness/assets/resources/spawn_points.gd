class_name SpawnPoints
extends Spawner


@export var points: Array[Vector2] = []


func spawn_objects() -> void:
	if objects.size() == 0:
		return
	
	clear_spawn_positions()
	
	for object in objects:
		var point := get_valid_point()
		spawn_positions.append(point)
		object.global_position = point
	
	super.spawn_objects()


func get_valid_point() -> Vector2:
	var attempt := 0
	var distance := min_distance
	
	while true:
		attempt += 1
		if attempt % 10 == 0 and distance != 0:
			distance -= 1
		
		var point: Vector2 = points.pick_random()
		
		if spawn_positions.size() > 0:
			for spawn_position in spawn_positions:
				if point.distance_to(spawn_position) >= distance:
					return point
		else:
			return point
	
	
	return Vector2.ZERO
