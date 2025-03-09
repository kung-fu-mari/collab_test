extends Control

@onready var player = get_node("../../BeanHands")
var ad_scene = preload("res://Scenes/Player/ad.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	player.ads_visible -= 1
	self.queue_free()

func _on_visit_site_button_pressed() -> void:
	var temp_ad_scene = ad_scene.instantiate()
	temp_ad_scene.get_node("")
	get_tree().get_root().get_node("Main/AdCanvas").add_child(temp_ad_scene)
	player.ads_visible += 1
