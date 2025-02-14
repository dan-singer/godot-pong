class_name PauseMenu extends PanelContainer

const front_end_scene = preload("res://scenes/front_end.tscn")


func _on_resume_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().paused = false
	queue_free()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(front_end_scene)
