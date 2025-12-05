@tool
extends Node

@export_range(0,5,0.1) var variant_pitch: float = 2
@export var sfx: Dictionary[String, AudioStream] = {
	"deflect": preload("res://sound/GameSFX/Swoosh/Retro Swooosh 02.wav"),
	"shoot": preload("res://sound/GameSFX/Weapon/laser/Retro Gun Laser SingleShot 01.wav"),
	"new_highscore": preload("res://sound/GameSFX/Events/Retro Event StereoUP 02.wav"),
	"dash": preload("res://sound/GameSFX/Bounce Jump/Retro Jump Simple C2 02.wav"),
	"crit": preload("res://sound/GameSFX/Magic/Retro Magic 06.wav"),
	"clang": preload("res://sound/GameSFX/FootStep/Retro FootStep Metal 01.wav")
}
@export var music: Dictionary[String, AudioStream] = {
	"song1": preload("res://sound/20second_rampage.ogg")
}

func play_sound(sound: AudioStream, source: Node=null, random_pitch:bool=true) -> void:
	var audio_player
	if source and source is Node2D:
		audio_player = AudioStreamPlayer2D.new()
		audio_player.global_position = source.global_position
	else:
		audio_player = AudioStreamPlayer.new()
	if random_pitch:
		audio_player.pitch_scale = 1.0 + randf_range(-variant_pitch/10.0, variant_pitch/10.0)
	audio_player.set_bus("SFX")
	add_child(audio_player)
	audio_player.stream = sound
	audio_player.play()
	print("Playing sound: ", sound)
	audio_player.connect("finished", Callable(audio_player, "queue_free"))


var current_music_player: AudioStreamPlayer = null
func play_music(music_stream: AudioStream) -> AudioStreamPlayer:
	var music_player = AudioStreamPlayer.new()
	music_player.set_bus("Music")
	add_child(music_player)
	music_player.stream = music_stream
	music_player.play()
	current_music_player = music_player
	return music_player

func stop_music() -> void:
	if current_music_player:
		current_music_player.stop()
		current_music_player.queue_free()
		current_music_player = null