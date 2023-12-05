extends Node2D

@onready var enemy = preload("res://Enemy/enemy.tscn")

func enemy_killed():
	var enemySpawn =  enemy.instantiate()
	enemySpawn.set_position(Vector2(randi_range(50, 1000), randi_range(50, 500)))
	self.add_child(enemySpawn)
