extends CharacterBody2D

@onready var anim_player = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# these two variables help stop 
# the animation player from restarting the run anim every physics frame
# which causes mr bean to only do the first half of run anim
var running = false
var already_running = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		running = true
		if direction < 0:
			$SpriteContainer.scale.x = -1
		else:
			$SpriteContainer.scale.x = 1
		velocity.x = direction * SPEED
	else:
		anim_player.pause()
		running = false
		already_running = false
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if running == true and already_running == false:
		already_running = true
		anim_player.play('run')
	move_and_slide()
