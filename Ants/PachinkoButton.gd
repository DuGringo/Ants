extends TextureButton

signal pachinko_pressed(pressed)

var is_pressed = false


func _on_PachinkoButton_pressed():
		is_pressed = !is_pressed
		emit_signal("pachinko_pressed",is_pressed)
