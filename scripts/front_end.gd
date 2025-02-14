extends Control

@onready var mode_collections: HBoxContainer = $VBoxContainer/Modes/ModeCollections
@onready var current_mode_collection: ModeCollectionContainer = $VBoxContainer/Modes/CurrentModeCollection
@onready var help_text: Label = $VBoxContainer/HelpPanel/MarginContainer/HelpText
@onready var help_panel: PanelContainer = $VBoxContainer/HelpPanel
@onready var header: Label = $VBoxContainer/PanelContainer/Header
@onready var back: Button = $VBoxContainer/PanelContainer/Back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	header.visible = false
	back.visible = false
	help_panel.modulate = Color(0,0,0,0)
	for child in mode_collections.get_children():
		if child is ModeCollectionButton:
			child.pressed.connect(open_mode_collection.bind(child))
			child.mouse_entered.connect(show_mode_collection_description.bind(child))

func open_mode_collection(button: ModeCollectionButton):
	help_panel.modulate = Color(0,0,0,0)
	header.visible = true
	back.visible = true
	header.text = button.mode_collection.header
	if button.mode_collection.modes.size() == 1:
		ModeManager.current_mode = button.mode_collection.modes[0]
		ModeManager.load_mode()
	mode_collections.visible = false
	current_mode_collection.visible = true
	current_mode_collection.set_collection(button.mode_collection)

func show_mode_collection_description(button: ModeCollectionButton):
	help_panel.modulate = Color(1,1,1,1)
	help_text.text = button.mode_collection.description
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	back.visible = false
	header.visible = false
	current_mode_collection.visible = false
	mode_collections.visible = true
