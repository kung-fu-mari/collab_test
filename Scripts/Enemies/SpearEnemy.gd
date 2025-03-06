extends CharacterBody2D

@onready var spawn_position := global_position
@onready var cliff_check = $Flipper/CliffRayCast
@onready var wall_check = $Flipper/TurnAroundRayCast
@onready var hitbox = $Flipper/RightHandSprite/SpearSprite/Hitbox
@onready var anim_player = $AnimationPlayer

@export var player : CharacterBody2D
@export var march_direction : int = 1

const KNOCKBACK = 600
const LAUNCH = 150
const FRICTION = 20
const MAX_HP := 20
const WALK_SPEED := 100
const RUN_SPEED := 130

var current_hp : int
var speed = WALK_SPEED
var state = "patrolling"

func _ready() -> void:
	current_hp = MAX_HP

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if state != "attacking":
		velocity.x = speed * march_direction
	else:
		velocity.x = 0
	move_and_slide()
	
func _process(_delta: float) -> void:
	if not cliff_check.is_colliding() and is_on_floor():
		state = "patrolling"
		march_direction *= -1
		$Flipper.scale.x *= -1
	if wall_check.is_colliding() and state != "chasing":
		march_direction *= -1
		$Flipper.scale.x *= -1
	if global_position.y > 550:
		die_and_respawn()
	if state == "chasing" or state == "attacking":
		if anim_player.current_animation != "spear_stab_1":
			chase_player()
	handle_animation()
		
func _on_chase_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('player') and state != "attacking":
		state = "chasing"
		speed = RUN_SPEED
	
func _on_chase_area_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		if anim_player.current_animation == "spear_stab_1":
			await anim_player.animation_finished
		state = "patrolling"
		speed = WALK_SPEED

func chase_player() -> void:
	if player.global_position.x > self.global_position.x:
		$Flipper.scale.x = 1
		march_direction = 1
	elif player.global_position.x < self.global_position.x:
		$Flipper.scale.x = -1
		march_direction = -1
		
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_weapon") and current_hp > 0:
		damage_flash()
		anim_player.stop()
		anim_player.play(anim_player.assigned_animation)
		take_knockback()
		take_damage()
		if area.is_in_group("bullet"):
			area.queue_free()

func damage_flash() -> void:
	$Flipper/BodySprite.modulate = Color.CRIMSON
	var color_tween = self.create_tween()
	color_tween.tween_property($Flipper/BodySprite, "modulate", Color.WHITE, 0.1)
		
func take_damage() -> void:
	current_hp -= 1
	if current_hp <= 0:
		die_and_respawn()
			
func take_knockback() -> void:
	if player.global_position.x > self.global_position.x:
		velocity.x -= KNOCKBACK
	else:
		velocity.x += KNOCKBACK
	velocity.y -= LAUNCH
	
func die_and_respawn() -> void:
	self.hide()
	await get_tree().create_timer(1).timeout
	current_hp = MAX_HP
	self.global_position = spawn_position
	self.show()

func _on_stab_area_body_entered(_body: Node2D) -> void:
	state = "attacking"
	
func set_spear_hitbox(value: bool) -> void:
	if value:
		state = "attacking"
	else:
		state = "chasing"
		
	hitbox.set_collision_layer_value(1, value)

func handle_animation() -> void:
	if state == "attacking":
		if anim_player.current_animation != "spear_stab_1":
			anim_player.play("spear_stab_1")
	elif state in ["patrolling", "chasing"]:
		if anim_player.current_animation != "run":
			anim_player.play("run")
