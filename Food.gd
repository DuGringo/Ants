extends KinematicBody2D

onready var stat = $Stats




func _on_HurtBox_area_entered(attack):
	stat.CUR_HP -= attack.damage




func _on_Stats_no_health():
	queue_free()
