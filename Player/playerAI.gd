extends AIController2D

# Stores the action sampled for the agent's policy, running in python
var move_action : Vector2 = Vector2(0,0)
var attack_action

@export var player : Node2D
@export var enemy : Node2D

func get_obs() -> Dictionary:
	var obs = [
		player.global_position.x,
		player.global_position.y,
		enemy.global_position.x,
		enemy.global_position.y
	]
	

	return {"obs":obs}
	
func reset():
	n_steps = 0
	needs_reset = false

func get_reward() -> float:	
	return reward
	
func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 2,
			"action_type": "continuous"
		},
		"attack_action" : {
			"size": 1,
			"action_type": "discrete"
		}
		}
	
func set_action(action) -> void:
	move_action = Vector2(
		clampf(action["move_action"][0], -1, 1),
		clampf(action["move_action"][1], -1, 1)
		)
	attack_action = action["attack_action"]
