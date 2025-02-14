class_name PauseMenu extends PanelContainer

const front_end_scene = preload("res://scenes/front_end.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	queue_free()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_packed(front_end_scene)
