extends Area2D

@export var fall_speed := 150.0

func _ready() -> void:
	add_to_group("doubles")

func _physics_process(delta):
	position.y += fall_speed * delta
	if position.y > 750.0 :
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		_play_sound("res://assets/sounds/sound3.wav")
		get_tree().root.get_node("game").double_balls()  # Adjust path if needed
		queue_free()
func _play_sound(path: String  ):
	var stream = load(path)
	if stream is AudioStream:
		if not $AudioStreamPlayer2D.playing :
			$AudioStreamPlayer2D.stream = stream
			$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
			$AudioStreamPlayer2D.play()
	else:
		push_error("Invalid audio stream at: " + path)
