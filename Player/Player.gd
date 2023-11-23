extends CharacterBody2D

@export var move_speed : float = 225
@onready var animation_tree = $AnimationTree

var health = 100
var outgoing_attack = false

func _process(delta):
	if health == 0:
		game_over()
	attack()

func attack():
	if Input.is_action_just_pressed("attack"):
		outgoing_attack = true
	else:
		outgoing_attack = false

func game_over():
	queue_free()
	get_tree().change_scene_to_file("res://Main/main.tscn")

func _physics_process(delta):
	var input_direction = Vector2 (
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if input_direction.x > 0:
		get_node("AnimatedSprite2D").flip_h = false
	if input_direction.x < 0:
		get_node("AnimatedSprite2D").flip_h = true
	
	if Input.get_action_strength("attack"):
		animation_tree.get("parameters/playback").travel("Attack")

	elif velocity != Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Run")
		animation_tree.set("parameters/Run/blend_position", input_direction)
	else:
		animation_tree.get("parameters/playback").travel("Idle")
		
	velocity = input_direction.normalized() * move_speed
	move_and_slide()
