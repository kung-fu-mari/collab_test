extends Area2D

@export_multiline var label_text : String
var tween_activated : bool = false
@export var speed : float = 0.0

func _ready() -> void:
	$Label.text = label_text
	$Label.visible_characters = 0
	if speed == 0.0:
		speed = $Label.text.length()/13




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and tween_activated == false:
		tween_activated = true
		var tween = self.create_tween()
		tween.tween_property($Label, "visible_characters", $Label.text.length(), speed)
