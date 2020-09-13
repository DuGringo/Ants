extends KinematicBody2D

onready var stat = $Stats
onready var softCollision = $SoftCollision

export var valor_nutricional = 10

var velocity = Vector2.ZERO

var mordida = false 

func _ready():
	stat.CLASS = "food"

func _physics_process(delta):
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 5
	else:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity)

func _on_HurtBox_area_entered(attack):
	stat.CUR_HP -= attack.damage




func _on_Stats_no_health():
	queue_free()
