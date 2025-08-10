extends Control

signal DSrestart

func _on_restart_button_button_up():
	DSrestart.emit()

func setEndScreen(message: String):
	$VBoxContainer/Label.text = message
