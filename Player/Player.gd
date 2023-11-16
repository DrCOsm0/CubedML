extends CharacterBody2D

@export var move_speed : float = 225

func _physics_process(delta):
	var input_direction = Vector2 (
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	print(input_direction)
	velocity = input_direction.normalized() * move_speed
	move_and_slide()
