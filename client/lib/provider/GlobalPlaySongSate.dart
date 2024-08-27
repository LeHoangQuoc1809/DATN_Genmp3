import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import '../../../models/song_model.dart';
import 'package:client/models/static_data_model.dart';

class MusicPlayState with ChangeNotifier {
  // List of songs in the current playlist
  List<Song> currentSongsList = [];

  // Currently playing song
  Song currentSong = Song(
    id: 1,
    name: "Default Song 1",
    duration: const Duration(minutes: 3, seconds: 33),
    picture: "Chua-Chau-Khai-Phong-Truc-Anh-Babe",
    listenCount: 0,
    lyric: "lyric",
    album_id: 1,
    artists: [],
    topics: [],
    genres: [],
  );

  // Playback state
  bool isPlaying = false;
  bool isLoading = false;
  Uint8List? uint8List;
  late AudioPlayer audioPlayer;

  // Animation controller for disc rotation
  late TickerProvider _tickerProvider;
  late AnimationController controllerDisc;

  // Stream subscription for position updates
  StreamSubscription<Duration>? positionSubscription;
  Duration currentPosition = Duration.zero;

  // Playback modes
  int mode = 0; // 0 = sequence, 1 = repeat one song, 2 = repeat list
  bool isShuffle = true;

  // Initialize MusicPlayState
  MusicPlayState({
    required TickerProvider tickerProvider,
  }) {
    audioPlayer = AudioPlayer();
    _tickerProvider = tickerProvider;

    controllerDisc = AnimationController(
      vsync: _tickerProvider,
      duration: const Duration(seconds: 5),
    );

    // Listen for audio player state changes
    audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        // Handle song completion based on playback mode
        await _handleSongCompletion();
      }
    });

    // Listen for position updates
    positionSubscription = audioPlayer.positionStream.listen((position) {
      currentPosition = position;
      notifyListeners();
    });
  }

  // Handle playback mode changes
  void setMode(int newMode) {
    mode = newMode;
    notifyListeners();
  }

  void setIsShuffle({required bool isShuffleVar}) {
    isShuffle = isShuffleVar;
  }

  // Add song to the end of the current playlist
  void addToLastCurrentSongsList(Song newSong) {
    currentSongsList.add(newSong);
    notifyListeners();
  }

  // Set the entire playlist
  void setCurrentSongsList(List<Song> newSongsList) {
    currentSongsList = newSongsList;
    notifyListeners();
  }

  // Set the currently playing song
  void setCurrentSong(Song newSongInNewList) {
    currentSong = newSongInNewList;
    notifyListeners();
  }

  // Toggle play/pause
  Future<void> toggleRotation() async {
    isPlaying = !isPlaying;
    notifyListeners();
  }

  // Handle the end of a song
  Future<void> _handleSongCompletion() async {
    if (mode == 1) {
      // Repeat the current song
      await handleRepeatSong();
    } else if (mode == 0) {
      // Play next song in sequence
      if (currentSongsList.last.id == currentSong.id) {
        await handleRepeatSong(); // Repeat the last song if at end of list
      } else {
        await onNextTap();
      }
    } else if (mode == 2) {
      // Repeat the playlist
      await audioPlayer.seek(Duration.zero); // Reset playback position
      await onNextTap(); // Move to the next song
    }
  }

  // Restart the current song
  Future<void> handleRepeatSong() async {
    await audioPlayer.seek(Duration.zero); // Seek to the beginning
    await audioPlayer.play(); // Start playing again
    isPlaying = true;
    notifyListeners();
  }

  // Toggle play/pause functionality
  Future<void> onPlayTap() async {
    if (isPlaying) {
      pause();
    } else {
      isLoading = true;
      notifyListeners();
      await play();
      isLoading = false;
      notifyListeners();
    }
    await toggleRotation();
  }

  // Play the next song
  Future<void> onNextTap() async {
    stop();
    getNextSong();
    isLoading = true;
    notifyListeners();
    await play();
    isLoading = false;
    isPlaying = true;
    notifyListeners();
  }

  // Play the previous song
  Future<void> onBackTap() async {
    stop();
    getPreviousSong();
    isLoading = true;
    notifyListeners();
    await play();
    isLoading = false;
    notifyListeners();
    await toggleRotation();
  }

  // Load an MP3 file from a URL
  Future<Uint8List> loadMp3File(int songId) async {
    String url = Song.getUrlMp3(songId);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load mp3');
    }
  }

  // Set audio from byte data
  Future<void> setAudioFromBytes(Uint8List bodyBytes) async {
    try {
      final audioUri = Uri.dataFromBytes(
        bodyBytes,
        mimeType: 'audio/mpeg',
      );
      final concatenatingAudioSource = ConcatenatingAudioSource(
        children: [AudioSource.uri(audioUri)],
      );
      await audioPlayer.setAudioSource(concatenatingAudioSource);
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // Start playing the current song
  Future<void> play() async {
    if (isPlaying) {
      stop();
    } else {
      if (uint8List == null) {
        uint8List = await loadMp3File(currentSong.id);
        await setAudioFromBytes(uint8List!);
      }
      controllerDisc.repeat();
      audioPlayer.play();
    }
  }

  // Pause the current song
  void pause() {
    controllerDisc.stop();
    audioPlayer.pause();
  }

  // Stop the current song
  void stop() {
    audioPlayer.seek(Duration.zero);
    audioPlayer.stop();
    uint8List = null;
    isPlaying = false;
    controllerDisc.stop();
    notifyListeners();
  }

  // Move to the next song in the playlist
  void getNextSong() {
    int currentIndex = currentSongsList.indexWhere((song) => song.id == currentSong.id);
    if (currentIndex == -1) return; // No match found

    if (currentIndex == currentSongsList.length - 1) {
      if (mode == 2) {
        currentSong = currentSongsList.first; // Loop back to the first song
      }
    } else {
      currentSong = currentSongsList[currentIndex + 1]; // Move to the next song
    }
    notifyListeners();
  }

  // Move to the previous song in the playlist
  void getPreviousSong() {
    int currentIndex = currentSongsList.indexWhere((song) => song.id == currentSong.id);
    if (currentIndex == -1) return; // No match found

    if (currentIndex == 0) {
      currentSong = currentSongsList.first; // Go to the first song if at start
    } else {
      currentSong = currentSongsList[currentIndex - 1]; // Move to the previous song
    }
    notifyListeners();
  }

  // Clean up resources
  @override
  void dispose() {
    audioPlayer.dispose();
    controllerDisc.dispose();
    positionSubscription?.cancel();
    super.dispose();
  }
}
