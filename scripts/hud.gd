class_name HUD extends CanvasLayer

@onready var winner: Label = $Winner
@onready var countdown: Label = $Countdown
var score_labels: Array[Label]
var countdown_remaining := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_labels.push_back($P0Score)
	score_labels.push_back($P1Score)
	winner.visible = false

func start_countdown(duration: float):
	countdown_remaining = duration
	
func set_winner(player: int):
	winner.text = "%s WINS" % ("P1" if player == 0 else "P2")
	winner.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if countdown_remaining > 0:
		countdown.visible = true
		countdown.text = str(ceil(countdown_remaining))
		countdown_remaining -= delta
	else:
		countdown.visible = false
		
func _on_pong_score_updated(player: int, score: int) -> void:
	score_labels[player].text = str(score)


func _on_pong_game_over(winner: int) -> void:
	set_winner(winner)
