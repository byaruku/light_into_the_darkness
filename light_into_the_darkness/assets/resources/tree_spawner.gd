class_name TreeSpawner
extends SpawnArea

@export var tree_coords: Array[Vector2]
@export var tree_count: int

@export var tile_map: TileMapLayer
@export var navigation_region: NavigationRegion2D
@export var start_position: Node2D
@export var goal_positions: Array[Node2D]

var attemps := 0


func _ready() -> void:
	polygon = collision_polygon.polygon
	get_max_and_min_from_polygron()
	for goal in goal_positions:
		spawn_positions.append(tile_map.local_to_map(goal.global_position))


func generate() -> void:
	attemps += 1
	print("Treespawn try: ", attemps)
	clear_trees()
	
	for i in range(tree_count):
		var pos : Vector2 = find_valid_position(false)
		spawn_tree(pos)
	
	await rebuild_navigation()
	
	if not is_path_possible():
		await generate()


func spawn_tree(pos: Vector2) -> void:
	tree_coords.shuffle()
	var tree_coord := tree_coords[0]
	var cell := tile_map.local_to_map(pos)
	tile_map.set_cell(cell, 0, tree_coord)
	
	spawn_positions.append(cell)


func rebuild_navigation() -> void:
	navigation_region.bake_navigation_polygon()
	await navigation_region.bake_finished
	await get_tree().process_frame


func is_path_possible() -> bool:
	var navigation_map := navigation_region.get_navigation_map()
	
	for goal_position in goal_positions:
		var path := NavigationServer2D.map_get_path(
			navigation_map,
			start_position.global_position,
			goal_position.global_position,
			true
		)
		
		if path.size() < 2:
			return false
	
	return true


func clear_trees() -> void:
	for cell in spawn_positions:
		tile_map.erase_cell(cell)

	spawn_positions.clear()
