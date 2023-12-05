extends CharacterBody2D

@export var move_speed : float = 225
@onready var animation_tree = $AnimationTree
@onready var ai_controller = $AIController2D

var enemies_killed = 0
var generation = 0
var rewards_this_gen = 0
var rewards_last_gen = 0

var health = 100
var outgoing_attack = false

func _ready():
	ai_controller.init(self)

func _process(delta):
	if health == 0:
		reset()
	attack()

func attack():
	if Input.is_action_just_pressed("attack") or ai_controller.attack_action:
		outgoing_attack = true
	else:
		outgoing_attack = false

func reset():
	self.global_position = Vector2(randi_range(50, 1000), randi_range(50, 500))
	health = 100
	if enemies_killed == 0:
		ai_controller.reward -= 1000
		rewards_this_gen -= 1000
	enemies_killed = 0
	rewards_last_gen = rewards_this_gen
	rewards_this_gen = 0
	generation += 1
	#get_tree().change_scene_to_file("res://Main/main.tscn")

func _physics_process(delta):
	if ai_controller.needs_reset:
		reset()
		ai_controller.reset()
		return
	var input_direction = Vector2 (
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if ai_controller.heuristic == "human":
		input_direction = input_direction.normalized()
	else:
		input_direction = ai_controller.move_action.normalized()
	
	if input_direction.x > 0:
		get_node("AnimatedSprite2D").flip_h = false
	if input_direction.x < 0:
		get_node("AnimatedSprite2D").flip_h = true
	
	if Input.get_action_strength("attack") or ai_controller.attack_action:
		animation_tree.get("parameters/playback").travel("Attack")

	elif velocity != Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Run")
		animation_tree.set("parameters/Run/blend_position", input_direction)
	else:
		animation_tree.get("parameters/playback").travel("Idle")
		
	velocity = input_direction.normalized() * move_speed
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "TileMap":
			ai_controller.reward -= 2
			rewards_this_gen -= 2

