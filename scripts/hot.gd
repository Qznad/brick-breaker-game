extends Area2D

@export var fall_speed := 150.0

func _ready() -> void:
	add_to_group("hots")

func _physics_process(delta):
	position.y += fall_speed * delta
	if position.y > 750.0 :
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		var all_balls = get_tree().get_nodes_in_group("balls")
		var ball_count = all_balls.size()

		var chosen_balls = []
		var max_hot_balls = int(ball_count * 0.1)
		if max_hot_balls < 1:
			max_hot_balls = 1  # At least affect one ball if any exist

		while chosen_balls.size() < max_hot_balls and all_balls.size() > 0:
			var random_index = randi() % all_balls.size()
			var ball = all_balls[random_index]
			all_balls.remove_at(random_index)
			chosen_balls.append(ball)
			# Apply hot effect
			ball.bouncing = false
			if ball.has_node("ColorRect"):
				ball.get_node("ColorRect").color = Color.RED

			# Start independent timer per ball
		queue_free()

# A simple function to play sounds (sounds still glitchy duo to man sounds trying to play at the same time )
func _play_sound(path: String  ):
	var stream = load(path)
	if stream is AudioStream:
		if not $bouncesound.playing :
			$bouncesound.stream = stream
			$bouncesound.pitch_scale = randf_range(0.9, 1.1)
			$bouncesound.play()
	else:
		push_error("Invalid audio stream at: " + path)
