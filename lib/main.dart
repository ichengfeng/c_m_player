import 'package:c_m_player/pages/home/model/home_player_model.dart';
import 'package:c_m_player/pages/home/widget/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:c_m_player/pages/home/home_page.dart';
import 'package:provider/provider.dart';

main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomePlayerModel()),
        // StreamProvider<Duration>.value(
        //   initialData: const Duration(),
        //   value: audioPlayerManager.audioPlayer.onAudioPositionChanged,
        // ),
      ],
      child: MaterialApp(
        title: 'C_M_PLAYER',
        theme: ThemeData(primarySwatch: Colors.orange, splashColor: Colors.transparent,),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}