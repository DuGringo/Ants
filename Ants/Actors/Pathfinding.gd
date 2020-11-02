extends Node2D
class_name Pathfinding


export (Color) var enabled_color
export(Color) var disabled_color

export(bool) var should_display_grid := false

onready var grid = $Grid

var grid_rects := {}

var astar = AStar2D.new()
var tilemap: TileMap




#will center
var half_cell_size: Vector2
#will map size
var used_rect: Rect2

func initialize(ground: TileMap):
	create_navigation_map(ground)

func create_navigation_map(tileMap: TileMap):
	self.tilemap = tileMap
	
	#center the tile
	half_cell_size = tileMap.cell_size / 2
	#get map size
	used_rect = tileMap.get_used_rect()
	
	#set the tiles that make up the grid, use the cells ins the tile that is filled.
	var tiles = tileMap.get_used_cells()
	#you can generate a list of cells with any width and height to change the grid instead of using regular one

	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)
	
	
func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		astar.add_point(id, tile)
		if should_display_grid:
			var rect := ColorRect.new()
			grid.add_child(rect)
		
			grid_rects[str(id)] = rect
		
			rect.modulate = Color(1,1,1, 0.5)
			rect.color = enabled_color
			
			rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			
			rect.rect_size = tilemap.cell_size
			rect.rect_position = tilemap.map_to_world(tile)


func connect_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		
		
		for x in range(3):
			for y in range(3):
				var target = tile + Vector2(x - 1, y - 1 ) # instead of 0,1,2 its -1,0,1
				var target_id = get_id_for_point(target)
				
				#dont connect to itself or to outside
				if tile == target or not astar.has_point(target_id):
					continue
					
				astar.connect_points(id, target_id, true)

func update_navigation_map():
	for point in astar.get_points():
		astar.set_point_disabled(point, false)
		if should_display_grid:
			grid_rects[str(point)].color = enabled_color
		
	var obstacles = get_tree().get_nodes_in_group("obstacles")
	
	for obstacle in obstacles:
		if obstacle is TileMap:
			var tiles = obstacle.get_used_cells()
			for tile in tiles:
				var id = get_id_for_point(tile)
				if astar.has_point(id):
					astar.set_point_disabled(id, true)
					if should_display_grid:
						grid_rects[str(id)].color = disabled_color

		if obstacle is KinematicBody2D:
			var tile_coord = tilemap.world_to_map(obstacle.global_position)
			var id = get_id_for_point(tile_coord)
			if astar.has_point(id):
				astar.set_point_disabled(id, true)
				if should_display_grid:
					grid_rects[str(id)].color = disabled_color


func get_id_for_point(point: Vector2):
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y
	#gives each tile a unique ID
	return x + y * used_rect.size.x

#start and end are both in world coordnates
func get_new_path(start: Vector2, end: Vector2) -> Array:
	#from world cood to tile coord
	var start_tile = tilemap.world_to_map(start)
	var end_tile = tilemap.world_to_map(end)
	
	# get the tile ID 
	var start_id = get_id_for_point(start_tile)
	var end_id = get_id_for_point(end_tile)
	
	#make sure there is a valid path
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return []
	
	#get the points between the 2 tiles
	var path_map = astar.get_point_path(start_id, end_id)
	
	#converts back to world coordnates so units can use it
	var path_world = []
	for point in path_map:
		var point_world = tilemap.map_to_world(point) + half_cell_size
		path_world.append(point_world)
		
	return path_world
	
	
	
	


func _on_Timer_timeout():
	update_navigation_map()
