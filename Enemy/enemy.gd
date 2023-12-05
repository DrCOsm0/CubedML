extends CharacterBody2D

@export var move_speed : float = 100
@onready var animation = get_node("AnimationPlayer")
@onready var player = get_node("../../Player/Player")

var chase = false
var in_range = false
var attack_cooldown = false
var in_player_attack_range = false

var health = 5

func _physics_process(delta):

	if chase == true:
		var direction = (player.position - self.position).normalized()
		velocity.x = direction.x * move_speed
		velocity.y = direction.y * move_speed
	else:
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func _process(delta):
	if health == 0:
		player.ai_controller.reward += 50
		player.rewards_this_gen += 50
		get_parent().enemy_killed() 
		player.enemies_killed += 1
		self.queue_free()
			
	attack()
	recieve_attack() 
	
func _ready():
	player.ai_controller.enemy = self
	animation.play("default")
	
func _on_player_chase_body_entered(body):
	if body.name == "Player":
		chase = true
		player.ai_controller.reward += 5
		player.rewards_this_gen += 5

func _on_player_chase_body_exited(body):
	if body.name == "Player":
		chase = false
	
func _on_player_collision_body_entered(body):
	if body.name == "Player":
		in_range = true
	
func _on_player_collision_body_exited(body):
	if body.name == "Player":
		in_range = false

func attack():
	if in_range == true and attack_cooldown == false:
		player.health = player.health - 1
		attack_cooldown = true
		$AttackCooldown.start()

func _on_attack_cooldown_timeout():
	attack_cooldown = false

func recieve_attack():
	if in_player_attack_range == true and player.outgoing_attack == true:
		health = health - 1
		self.modulate.a = self.modulate.a - 0.01
		player.ai_controller.reward += 10
		player.rewards_this_gen += 10

func _on_recieve_attack_body_entered(body):
	if body.name == "Player":
		in_player_attack_range = true

func _on_recieve_attack_body_exited(body):
	if body.name == "Player":
			in_player_attack_range = false
