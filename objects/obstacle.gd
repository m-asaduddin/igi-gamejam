extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	#if body.is_in_group("player"):
	# Apply damage and bounce through a method on the player
	if body is Player:
		print("player receive damage")
		body.take_damage_and_bounce(global_position)
