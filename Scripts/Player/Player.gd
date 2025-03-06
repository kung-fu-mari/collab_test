extends CharacterBody2D

@onready var anim_player := $AnimationPlayer
@onready var hitbox := $SpriteContainer/RightHandSprite/SwordSprite/Hitbox

const SPEED := 300.0
const JUMP_VELOCITY := -400.0
const MAX_JUMPS := 2

var jumps_left := MAX_JUMPS
var current_state : String = "idle"
#var running := false
#var swinging := false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		jumps_left = MAX_JUMPS
		
	if Input.is_action_just_pressed("up") and jumps_left > 0:
		jumps_left -= 1
		velocity.y = JUMP_VELOCITY
		

	var direction := Input.get_axis("left", "right")
	if direction:
		if current_state != "swinging":
			current_state = "running"
		if direction < 0:
			$SpriteContainer.scale.x = -1
		else:
			$SpriteContainer.scale.x = 1
		velocity.x = direction * SPEED
	else:
		if velocity.x == 0:
			if current_state != "swinging":
				current_state = "idle"
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
func _process(_delta: float) -> void:
	if global_position.y > 550:
		get_tree().reload_current_scene()
	check_for_attack()
	handle_animation()

func check_for_attack() -> void:
	if Input.is_action_pressed("attack") and current_state != "swinging":
		current_state = "swinging"
		hitbox.set_collision_layer_value(1, true)

func handle_animation() -> void:
	if current_state == "swinging":
		if anim_player.current_animation != "swing_sword_1":
			anim_player.play("swing_sword_1")
	elif current_state == "running":
		if anim_player.current_animation != "run":
			anim_player.play("run")
	else:
		if anim_player.current_animation != "idle" and is_on_floor():
			anim_player.play("idle")

func set_sword_hitbox(value: bool) -> void:
	if value:
		current_state = "swinging"
	else:
		current_state = ""
	hitbox.set_collision_layer_value(1, value)
