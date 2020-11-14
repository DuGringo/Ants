extends Control

onready var progress = $ProgressBar
onready var stat = $"../Stats"

func _ready():
	self.visible = false

func _process(delta):
	progress.value = stat.HUNGER
