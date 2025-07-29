extends Node2D


# Called when the node enters the scene tree for the first time.
var game_started = false

func _ready() -> void:
	game_started = false
	await get_tree().create_timer(0.5).timeout
	game_started = true



func _on_area_2d_body_entered(body: Node2D) -> void:
	if not game_started:
		return
	if body.is_in_group("balls"):
		body.remove_from_group("balls")  # Ensure it's no longer counted
		body.queue_free()  # Remove the ball that falls

		# Delay check to let the scene tree catch up (still good practice)
		await get_tree().process_frame

		var balls = get_tree().get_nodes_in_group("balls")
		if balls.size() == 0:
			$Menu._cleaning_up()
			$Menu/main/title.text = "GAME OVER"
			$Menu/main/score.text = "0 pts"
			$Menu.visible = true
			$Menu/AnimationPlayer.play("pausing")
			get_tree().paused = true
func _winner() -> void:
	$Menu._cleaning_up()
	$Menu/main/title.text = "WINNER"
	$Menu/main/score.text = "<3 pts"
	$Menu.visible = true
	$Menu/AnimationPlayer.play("pausing")
	get_tree().paused = true



@export var ball_scene: PackedScene

# Max balls that can exist ( not limiting the balls can lead to overflow breaking the game !
const MAX_BALLS = 248

func double_balls():
	var balls = get_tree().get_nodes_in_group("balls")
	var current_count = balls.size()
	if current_count >= MAX_BALLS:
		return  # Already reached max balls, do nothing
	
	for ball in balls:
		if get_tree().get_nodes_in_group("balls").size() >= MAX_BALLS:
			break  # Stop spawning more if max reached
		
		var new_ball = ball_scene.instantiate()
		new_ball.position = ball.position + Vector2(10, 0)
		new_ball.direction = Vector2(-ball.direction.x, ball.direction.y).normalized()
		new_ball.speed = ball.speed
		new_ball.add_to_group("balls")
		get_parent().add_child(new_ball)
