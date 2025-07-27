extends Area2D

@export var fall_speed := 150.0

func _physics_process(delta):
	position.y += fall_speed * delta
	if position.y > 750.0 :
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().root.get_node("game").double_balls()  # Adjust path if needed
		queue_free()
