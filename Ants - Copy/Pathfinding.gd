extends Node2D
class_name Pathfinding

var astar = AStar2D.new()
var tilemap: TileMap

#will center
var half_cell_size: Vector2
#will map size
var used_rect: Rect2


func create_navigation_map(tilemap: TileMap):
	self.tilemap = tilemap
	
	#center the tile
	half_cell_size = tilemap.cell_size / 2
	#get map size
	used_rect = tilemap.get_used_rect()
	
	#set the tiles that make up the grid, use the cells ins the tile that is filled.
	var tiles = tilemap.get_used_cells()
	#you can generate a list of cells with any width and height to change the grid instead of using regular one

	add_traversable_tiles(tiles)
	connect_traversable_tiles(tiles)
	
	
func add_traversable_tiles(tiles: Array):
	for tile in tiles:
		var id = get_id_for_point(tile)
		astar.add_point(id, tile)

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
	
	
	
	
