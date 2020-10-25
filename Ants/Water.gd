extends TileMap

var WIDTH = 160
var HEIGHT = 90


export var octaves = 2
export var period = 7.5
export var persistence = 0.5
export var lacunarity = 2
#export var frequency = 0.005
#2,7,5,5

const TILES = {
	'water': 0,
	'nothing': 1,

}



var noise


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
			#centraliza, mas como meu centered eh OFF, eh melhor nao centralizar
#			$TileMap2.set_cellv(Vector2(x-WIDTH/2, y-HEIGHT/2), _get_tile_index(noise.get_noise_2d(float(x),float(y))))
			if _get_tile_index(noise.get_noise_2d(float(x),float(y))) != null:
				self.set_cellv(Vector2(x, y), _get_tile_index(noise.get_noise_2d(float(x),float(y))))
			pass
	self.update_bitmask_region()

func _get_tile_index(noise_sample):
	if noise_sample < 0.6:
		return null
	return TILES.water
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
