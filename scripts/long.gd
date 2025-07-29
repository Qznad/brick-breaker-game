extends Area2D

@export var fall_speed := 150.0

func _ready() -> void:
	add_to_group("longs")

func _physics_process(delta):
	position.y += fall_speed * delta
	if position.y > 750.0 :
		queue_free()


func _on_body_entered(body):
	if body.name == "Player":
		var player = get_tree().get_nodes_in_group("player")[0]
		player.longer()
		queue_free()


func _play_sound(path: String  ):
	var stream = load(path)
	if stream is AudioStream:
		if not $bouncesound.playing :
			$bouncesound.stream = stream
			$bouncesound.pitch_scale = randf_range(0.9, 1.1)
			$bouncesound.play()
	else:
		push_error("Invalid audio stream at: " + path)
