extends Camera2D

var posicao = Vector2(0,0)

export var speed = 10

export var zoomspeed = 10.0
export var zoommargin = 0.1 
export var zoomsmooth = 1

export var zoomMin = 0.25
export var zoomMax = 1

var zoompos = Vector2()
var zoomfactor = 1.0
var zooming = false

var tempposition = Vector2(0,0)

func _ready():
	
	zoom = Vector2(0.3, 0.3)
	
	
#pass
#
func _physics_process(delta):

#	#smooth movement
#	var inpx = (int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")))
#	var inpy = (int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up")))
#
#	print(inpx)
#	print(inpy)
#	position.x = lerp(position.x, position.x + inpx * speed * zoom.x, speed * delta)
#	position.y = lerp(position.y, position.y + inpy * speed * zoom.y, speed * delta)
#	print(position)#
	


	#segue a formiga selecionada
	if get_tree().current_scene.find_node("*StatsUI*", true , false):
		smoothing_speed = 2
		if get_tree().current_scene.same != null:
			position = get_tree().current_scene.same.global_position
	#segue o mouse
	else:
		smoothing_speed = 0.7
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
			
	if Input.is_action_just_pressed("ui_focus_next"):
		global_position = get_tree().current_scene.get_node("Formigueiro").global_position
