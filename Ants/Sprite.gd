extends Sprite

var WIDTH = 1280
var HEIGHT = 720

export var octaves = 2
export var period = 7.5
export var persistence = 0.5
export var lacunarity = 2
#2,7,5,5

const TILES = {
	'dirt': 0,
	'grass': 1,

}



var noise
var noisewater

# Called when the node enters the scene tree for the first time.
func _ready():
# Instantiate
	randomize()
	noise = OpenSimplexNoise.new()
	#noisewater = OpenSimplexNoise.new()
	
	# Configure
	noise.seed = randi()
	noise.octaves = octaves
	noise.period = period
	noise.persistence = persistence
	noise.lacunarity = lacunarity

	#noisewater.seed = randi()
	#noisewater.octaves = 2
	#noisewater.period = 40.0
	#noisewater.persistence = 0.5
	#noisewater.lacunarity = 2

	_generate_world()
	

func _generate_world():
	for x in WIDTH:
		for y in HEIGHT:
			$TileMap2.set_cellv(Vector2(x-WIDTH/2, y-HEIGHT/2), _get_tile_index(noise.get_noise_2d(float(x),float(y))))
	$TileMap2.update_bitmask_region()

func _get_tile_index(noise_sample):
	if noise_sample < 0.3:
		return TILES.dirt
	return TILES.grass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
