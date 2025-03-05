extends CharacterBody2D

@onready var spawn_position := global_position

@export var player : CharacterBody2D

const KNOCKBACK = 300
const LAUNCH = 150
const FRICTION = 20
const MAX_HP := 10

var current_hp : int


func _ready() -> void:
	current_hp = MAX_HP

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	move_and_slide()

func _process(delta: float) -> void:
	if global_position.y > 550:
		die_and_respawn()
		
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_weapon") and current_hp > 0:
		damage_flash()
		take_knockback()
		take_damage()

func damage_flash() -> void:
	$BodySprite.modulate = Color.CRIMSON
	var color_tween = self.create_tween()
	color_tween.tween_property($BodySprite, "modulate", Color.WHITE, 0.1)
		
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
