extends Node2D

signal paddleExit()

func _on_area_2d_area_exited(area):
	paddleExit.emit()
	
