class_name ModeCollectionContainer extends HBoxContainer

var mode_button_scene: PackedScene = preload("res://scenes/mode_button.tscn")
@export var mode_collection: ModeCollection

func _ready() -> void:
	set_collection(mode_collection)

func set_collection(collection: ModeCollection):
	mode_collection = collection
	for child in get_children():
		child.queue_free()
	if mode_collection:
		for mode_config: ModeConfig in mode_collection.modes:
			var button: ModeConfigButton = mode_button_scene.instantiate()
			button.set_mode(mode_config)
			add_child(button)
