extends KinematicBody2D

onready var stat = $Stats




func _on_HurtBox_area_entered(area):
	stat.CUR_HP -= 1




func _on_Stats_no_health():
	queue_free()
