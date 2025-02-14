extends ColorRect

var pong: Pong
func _ready() -> void:
	pong = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pong_score_updated(player: int, score: int) -> void:
	var tween = get_tree().create_tween()
	var material_prop = "l_progress" if player == 0 else "r_progress"
	var start_progress = material.get_shader_parameter(material_prop)
	var target_progress = float(score) / pong.points_to_win
	var set_progress = func(v: float):
		material.set_shader_parameter(material_prop, v)
	tween.tween_method(set_progress, start_progress, target_progress, 1.0)
