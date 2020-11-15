extends Node2D

onready var strengthbar = $StrengthBar
onready var Ball = load("res://UI/Pachinko/Ball.tscn")
onready var formigueiro = get_tree().current_scene.get_node("Formigueiro")

var ballready = null

#var score = [0,0,0,0,0]

#Impulso vertical: minimo -430, Maximo -1500
var y = -400

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if formigueiro.balls_count > 0:
		var ball = Ball.instance()
		ball.position = Vector2(390,415)
		var board = self.add_child(ball)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	if Input.is_action_pressed("space"):
		y -= 20
		if y < -1550:
			y = -400
	strengthbar.value = -y
func _input(event):
	if event is InputEventKey:
		if event.is_action_released("space"):
			if ballready != null:
				ballready.apply_impulse(Vector2(0,15),Vector2(0,y))
			y = -400

func _on_Spring_body_entered(body):
	ballready = body

func _on_Spring_body_exited(body):
	ballready = null

func _on_Area2D_body_exited(body):
	body.set_collision_mask(32768)
