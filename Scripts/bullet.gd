extends Area2D

var speed = 8
var dir = 0
var shooter = null

func _physics_process(delta: float) -> void:
	position += Vector2(speed * dir,0)

func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return
	queue_free()
