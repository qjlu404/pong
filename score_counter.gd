extends Control

@onready var score: int = 0
@onready var ScoreDisplay = $ScoreDisplay
func increase():
	score+=1
	ScoreDisplay.text = str(score)

func reset():
	score=0
	ScoreDisplay.text = str(score)
