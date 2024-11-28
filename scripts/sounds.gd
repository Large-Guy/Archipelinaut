extends Node

var pitch_chains: Dictionary = {}

func play(sound, randomize_pitch: float = 0):
	var player = AudioStreamPlayer.new()
	get_tree().current_scene.add_child(player)
	player.stream = sound
	player.pitch_scale = 1 + randf_range(-randomize_pitch,randomize_pitch)
	player.play()
	await player.finished
	player.queue_free()

func play_pitch_chain(sound, pitch_inc: float = 0.1):
	var pitch = 1.0
	if pitch_chains.has(sound):
		pitch = pitch_chains[sound]
		pitch_chains[sound] += pitch_inc
	else:
		pitch_chains[sound] = 1.0 + pitch_inc
	var player = AudioStreamPlayer.new()
	get_tree().current_scene.add_child(player)
	player.stream = sound
	player.pitch_scale = pitch
	player.play()
	await player.finished
	player.queue_free()

func _process(delta):
	for sound in pitch_chains:
		pitch_chains[sound] -= delta
		if pitch_chains[sound] <= 1:
			pitch_chains.erase(sound)
