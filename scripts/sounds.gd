extends Node

func play(sound):
	var player = AudioStreamPlayer.new()
	get_tree().current_scene.add_child(player)
	player.stream = sound
	player.play()
	await player.finished
	player.queue_free()
