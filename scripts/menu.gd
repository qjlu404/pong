extends Control

signal menuPlay
signal menuClose

func _on_play_button_button_up():
	menuPlay.emit()


func _on_close_button_button_up():
	menuClose.emit()
