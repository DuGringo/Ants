extends CanvasLayer

func _ready():
	set_visible(false)

func _input(event):
	if event.is_action_pressed("ui_pause"): #escape button
		set_visible(!get_tree().paused) # if not paused, then hide
		get_tree().paused = !get_tree().paused #togle pause status


func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible
		
func _on_Button_pressed():
	get_tree().paused = false
	set_visible(false)

		
func _on_FullScreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen


func _on_Borderless_pressed():
	OS.window_borderless = !OS.window_borderless


func _on_Exit_pressed():
	get_tree().quit()


func _on_VolumeSlider_value_changed(value):
	if value == -40:
		value = -100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), float(value))
