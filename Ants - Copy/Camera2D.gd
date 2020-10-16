extends Camera2D

export var zoomspeed = 10.0
export var zoommargin = 0.1 
export var zoomsmooth = 1

export var zoomMin = 0.25
export var zoomMax = 1

var zoompos = Vector2()
var zoomfactor = 1.0
var zooming = false

onready var timer = $Timer2
var just_started = true


func _ready():
	
	zoom = Vector2(0.3, 0.3)
	timer.start(2)

	
#pass
#
func _physics_process(delta):

	#segue a formiga selecionada
	if get_tree().current_scene.find_node("*StatsUI*", true , false):
		set_drag_margin(0 , 0.1)
		set_drag_margin(1 , 0.1)
		set_drag_margin(2 , 0.1)
		set_drag_margin(3 , 0.1)
		smoothing_speed = 2
		if get_tree().current_scene.same != null:
			position = get_tree().current_scene.same.global_position
	#segue o mouse
	else:
		if just_started:
			position = get_tree().current_scene.get_node("Formigueiro").global_position
			smoothing_speed = 15
		else:
			set_drag_margin(0 , 0.7)
			set_drag_margin(1 , 0.7)
			set_drag_margin(2 , 0.7)
			set_drag_margin(3 , 0.7)
			smoothing_speed = 2
			position = get_global_mouse_position()

	#zoom
	zoom.x = lerp(zoom.x, zoom.x * zoomfactor, zoomsmooth * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomfactor, zoomsmooth * delta)
	
	zoom.x = clamp(zoom.x, zoomMin, zoomMax)
	zoom.y = clamp(zoom.y, zoomMin, zoomMax)
	
	if not zooming:
		zoomfactor = 1.0
		
func _input(event):
	if abs(zoompos.x - get_global_mouse_position().x) > zoommargin:
		zoomfactor = 1.0
	if abs(zoompos.y - get_global_mouse_position().y) > zoommargin:
		zoomfactor = 1.0
		
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoomfactor -= 0.01 * zoomspeed
				zoompos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomfactor += 0.01 * zoomspeed
				zoompos = get_global_mouse_position()
		else:
			zooming = false
			


func _on_Timer2_timeout():
	just_started = false
	timer.queue_free()