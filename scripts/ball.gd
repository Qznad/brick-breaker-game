extends CharacterBody2D

# Adjust the speed and acceleration at your need
@export var start_speed: int = 150
@export var accel: int = 5
@export var max_x_vector: float = 1.0
@export var paddle_width_default: float = 120.0


var bouncing = true
var speed: int
var direction: Vector2
var win_size: Vector2


# Powerup drop chances 3% 1% 6% 
var powerup_weights := [
	[preload("res://scenes/double.tscn"),3],
	[preload("res://scenes/hot.tscn"),1],
	[preload("res://scenes/long.tscn"),6]
]

var powerup_drop_chance := 30  # Overall % chance of dropping a power-up
var hot_bricks_count = 0
func _ready() -> void:
	add_to_group("balls")
	win_size = get_viewport_rect().size

	# Only reset the ball if it's the original (not a duplicate)
	if position == Vector2.ZERO:
		reset_ball()

func choose_weighted_powerup():
	var total_weight = 0
	for item in powerup_weights:
		total_weight += item[1]

	var rand_value = randi() % total_weight
	var current = 0
	for item in powerup_weights:
		current += item[1]
		if rand_value < current:
			return item[0]
	return null


func reset_ball() -> void:
	# Set initial position - you might want to export or pass this dynamically
	position = Vector2(576, 448)
	speed = start_speed
	direction = random_direction()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction * speed * delta)
	if collision:
		var collider = collision.get_collider()
		print(collider.name)
		if collider.is_in_group("player"):
			
			_play_bounce("res://assets/sounds/bump.ogg")
			speed += accel
			direction = new_direction(collider)
		elif collider.name.begins_with("@") or collider.name.begins_with("brick") :
			_play_bounce("res://assets/sounds/bump.ogg")
			# Remove brick node and bounce
			collider.queue_free()
			if bouncing :
				
				direction = direction.bounce(collision.get_normal())
			else :
				#HOT POWER IS ON (can destroy 25 blocks without bouncing !
				_play_bounce("res://assets/sounds/block_broken.wav",false)
				hot_bricks_count +=1
				if hot_bricks_count == 25 :
					hot_bricks_count = 0
					bouncing = true
					if self.has_node("ColorRect"):
						self.get_node("ColorRect").color = Color.WHITE
						print("power off")
			# Random chance to drop a power-up (e.g., 30% chance)
			if randi() % 100 < powerup_drop_chance:
				var selected_scene = choose_weighted_powerup()
				if selected_scene:
					var powerup = selected_scene.instantiate()
					powerup.position = position
					get_tree().current_scene.add_child(powerup)

		else:
			_play_bounce("res://assets/sounds/bump_2.ogg")
			# Bounce for all other collisions
			direction = direction.bounce(collision.get_normal())

func random_direction() -> Vector2:
	var new_dir = Vector2(randf_range(-1.0, 1.0), -1).normalized()
	# Ensure direction.x is never zero to avoid straight vertical movement
	if abs(new_dir.x) < 0.1:
		new_dir.x = sign(new_dir.x) * 0.1
	return new_dir

func new_direction(collider) -> Vector2:
	var ball_x = position.x
	var paddle_x = collider.position.x
	var dist = ball_x - paddle_x  # horizontal offset from paddle center
	var shape = collider.get_node("CollisionShape2D").shape
	var paddle_width = paddle_width_default
	if shape is RectangleShape2D:
		paddle_width = shape.extents.x * 2.0
	# Clamp dist to paddle bounds to avoid weird direction
	dist = clamp(dist, -paddle_width / 2, paddle_width / 2)
	# Calculate direction vector
	var new_dir = Vector2()
	new_dir.y = -1  # always bounce upward
	new_dir.x = (dist / (paddle_width / 2.0)) * max_x_vector
	new_dir = new_dir.normalized()
	return new_dir
func _play_bounce(path: String , stop = true ):
	var stream = load(path)
	if stream is AudioStream:
		if $bouncesound.playing and stop:
			$bouncesound.stop()
		$bouncesound.stream = stream
		$bouncesound.pitch_scale = randf_range(0.9, 1.1)
		$bouncesound.play()
	else:
		push_error("Invalid audio stream at: " + path)
