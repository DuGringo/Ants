extends Camera2D

export var zoomspeed = 10.0
export var zoommargin = 0.1 
export var zoomsmooth = 1

export var zoomMin = 0.25
export var zoomMax = 1.25

var zoompos = Vector2()
var zoomfactor = 1.0
var zooming = false

onready var robotbutton = $"../CanvasLayer/RobotAntButton"
var follow_robot = false

onready var timer = $Timer2
var just_started = true


func _ready():
	
	zoom = Vector2(0.3, 0.3)
	timer.start(2)
	robotbutton.connect("robot_pressed",self,"_handle_robot")

	
#pass
#
func _physics_process(delta):
	if follow_robot:
		set_drag_margin(0 , 0.1)
		set_drag_margin(1 , 0.1)
		set_drag_margin(2 , 0.1)
		set_drag_margin(3 , 0.1)
		smoothing_speed = 10
		position = get_node("../AntsManager/Player").global_position
		zoom = Vector2(0.2, 0.2)
	#segue a formiga selecionada
	elif get_tree().current_scene.find_node("*StatsUI*", true , false):
		set_drag_margin(0 , 0.1)
		set_drag_margin(1 , 0.1)
		set_drag_margin(2 , 0.1)
		set_drag_margin(3 , 0.1)
		smoothing_speed = 2
		if get_tree().current_scene.get_node("SpawnerManager").same != null:
			position = get_tree().current_scene.get_node("SpawnerManager").same.global_position
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
		if event.is_pressed() and !follow_robot:
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoomfactor -= 0.01 * zoomspeed
				zoompos = get_global_mouse_position()
			if event.button_index == BUTTON_WHEEL_DOWN:
				zoomfactor += 0.01 * zoomspeed
				zoompos = get_global_mouse_position()
		else:
			zooming = false
			
func _handle_robot(is_pressed):
	if is_pressed:
		follow_robot = true
	else:
		follow_robot = false

func _on_Timer2_timeout():
	just_started = false
	timer.queue_free()
