extends Label


# Called when the node enters the scene tree for the first time.
@onready var player = get_node("../../Player/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Rewards last gen: " + str(player.rewards_last_gen) #+ " " + str(get_node("../../Enemy/Enemy").health) 
