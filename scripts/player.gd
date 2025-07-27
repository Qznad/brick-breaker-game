extends CharacterBody2D

@export var speed: float = 300.0
@export var fixed_y: float = 550.0
@export var paddle_width: float = 120.0  # Initial paddle width

var window_width: float
var original_width: float
var active_long_powerups: int = 0
var long_powerup_timer: Timer
const MAX_LONG_POWERUPS := 3  # Prevent the paddle from becoming too big

func _ready() -> void:
	add_to_group("player")
	window_width = get_viewport().get_visible_rect().size.x
	original_width = paddle_width

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	velocity.y = 0
	move_and_slide()

	# Clamp X position to stay on screen
	var half_width = paddle_width / 2
	position.x = clamp(position.x, half_width, window_width - half_width)

	# Lock Y position
	position.y = fixed_y

func reset() -> void:
	position.x = window_width / 2

func longer() -> void:
	if active_long_powerups >= MAX_LONG_POWERUPS:
		long_powerup_timer.start(7.0)  # Refresh timer even if maxed
		return

	if long_powerup_timer == null:
		long_powerup_timer = Timer.new()
		long_powerup_timer.one_shot = true
		add_child(long_powerup_timer)
		long_powerup_timer.timeout.connect(_on_long_powerup_timeout)

	active_long_powerups += 1
	_update_paddle_size()
	long_powerup_timer.start(7.0)

func _on_long_powerup_timeout() -> void:
	active_long_powerups -= 1
	if active_long_powerups > 0:
		long_powerup_timer.start(7.0)
	_update_paddle_size()

func _update_paddle_size() -> void:
	var scale_factor = 1.5 ** active_long_powerups
	var new_width = original_width * scale_factor

	# Prevent paddle from becoming wider than screen
	var max_width = window_width - 40  # 20px margin on each side
	if new_width > max_width:
		new_width = max_width
		scale_factor = new_width / original_width

	paddle_width = new_width
	scale.x = scale_factor
