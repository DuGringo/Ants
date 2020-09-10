extends KinematicBody2D

onready var stat = $Stats
export var valor_nutricional = 10

var mordida = false 



func _on_HurtBox_area_entered(attack):
	stat.CUR_HP -= attack.damage




func _on_Stats_no_health():
	mordida = true
	queue_free()
