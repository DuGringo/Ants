extends Sprite

var WIDTH = 640
var HEIGHT = 360

const TILES = {
	'grass': 0,
	'dirt': 1,
}

var noise
var noisewater

# Called when the node enters the scene tree for the first time.
func _ready():
# Instantiate
	randomize()
	noise = OpenSimplexNoise.new()
	noisewater = OpenSimplexNoise.new()
	
	# Configure
	noise.seed = randi()
	noise.octaves = 2
	noise.period = 7.5
	noise.persistence = 0.5
	noise.lacunarity = 2

	noisewater.seed = randi()
	noisewater.octaves = 2
	noisewater.period = 40.0
	noisewater.persistence = 0.5
	noisewater.lacunarity = 2

	_generate_world()
	
func _generate_world():
	for x in WIDTH:
		for y in HEIGHT:
			$TileMap.set_cellv(Vector2(x-WIDTH/2, y-HEIGHT/2), _get_tile_index(noise.get_noise_2d(float(x),float(y))))
	$TileMap.update_bitmask_region()

func _get_tile_index(noise_sample):
	if noise_sample < 0.1:
		return TILES.dirt
	return TILES.grass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
