extends Node

#Music

#Sounds
const HIT : AudioStreamMP3 = preload("res://Sounds/hit.mp3")
const BUTTON : AudioStreamMP3 = preload("res://Sounds/button.mp3")

#Refrences
@onready var music_players = $Music.get_children()
@onready var sound_players = $Sounds.get_children()

func play_sound(sound):
	for player in sound_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break

func play_music(sound):
	for player in music_players:
		if not player.playing:
			player.stream = sound
			player.play()
			break
