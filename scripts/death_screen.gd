extends Control

signal DSrestart

func _on_restart_button_button_up():
	DSrestart.emit()
