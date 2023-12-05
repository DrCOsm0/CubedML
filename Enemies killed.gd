extends Label


# Called when the node enters the scene tree for the first time.
@onready var player = get_node("../../Player/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Enemies killed this gen: " + str(player.enemies_killed) #+ " " + str(get_node("../../Enemy/Enemy").health) 
