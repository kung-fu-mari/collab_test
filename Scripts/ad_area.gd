extends Area2D

@onready var player = $"../BeanHands"
var ad_scene = preload("res://Scenes/Player/ad.tscn")

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player.ads_visible += 1
		var temp_ad_scene = ad_scene.instantiate()
		temp_ad_scene.get_node("")
		get_tree().get_root().get_node("Main/AdCanvas").add_child(temp_ad_scene)
