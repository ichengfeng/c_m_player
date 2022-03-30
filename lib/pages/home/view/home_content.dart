import 'package:c_m_player/pages/home/widget/audio_player.dart';
import 'package:c_m_player/widgets/separate_line/separate_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

import '../data/song_list.dart';
import '../model/home_player_model.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/home/ic_home_bg_cat.png"),
          fit: BoxFit.cover
        ),
      ),
      child: Row(
        children: const [
          Flexible(child: PlayListArea(),flex: 1,),
          Flexible(child: PlayerArea(),flex: 3,),
        ],
      ),
    );
  }
}

///播放列表
class PlayListArea extends StatelessWidget {
  const PlayListArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: songs.length,
      itemBuilder: (ctx,index) {
        SongModel model = songs[index];
        return GestureDetector(
          child: Container(
            // height: 49,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Text(
              model.songName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          onTap: (){
            context.read<HomePlayerModel>().current = model;
            audioManager.playLocal("${model.songName}.mp3");
          },
        );
      },
      separatorBuilder: (ctx,index){
        return const SeparateLineWidget();
      },
    );
  }
}

///播放控制区域
class PlayerArea extends StatefulWidget {
  const PlayerArea({Key? key}) : super(key: key);

  @override
  State<PlayerArea> createState() => _PlayerAreaState();
}

class _PlayerAreaState extends State<PlayerArea> with SingleTickerProviderStateMixin{

  //动画控制器
  late AnimationController controller;
  late Animation animation;
  bool playing = false;
  double _currentSliderValue = 0;
  late Duration _duration;

  @override
  void initState() {
    super.initState();

    ///唱片旋转动画
    controller =
        AnimationController(duration: const Duration(seconds: 4), vsync: this,);
    //动画开始、结束、向前移动或向后移动时会调用StatusListener
    animation =  Tween<double>(
      begin: 1,
      end: 300,
    ).animate(controller)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
        controller.forward();
        playing = true; //正向执行 结束时会回调此方法
      } else if (status == AnimationStatus.dismissed) {
        //反向执行 结束时会回调此方法
      }
    });

    ///获取音乐时长
    audioManager.player.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });

    ///获取当前播放进度
    audioManager.player.onAudioPositionChanged.listen((Duration currentDuration) {
      setState(() {
        _currentSliderValue = (currentDuration.inMilliseconds/_duration.inMilliseconds)*100.round();
      });
    });

    audioManager.player.onPlayerStateChanged.listen((PlayerState state) {
      switch(state){
        case PlayerState.STOPPED: {
          controller.stop();
          break;
        }
        case PlayerState.PLAYING: {
          controller.forward();
          break;
        }
        case PlayerState.PAUSED: {
          controller.stop();
          break;
        }
        case PlayerState.COMPLETED: {
          controller.stop();
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SongModel model = context.watch<HomePlayerModel>().current;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            alignment: Alignment.center,
            turns: controller,
            child: GestureDetector(
              child: Image.asset('assets/home/ic_home_cd.png',fit: BoxFit.cover,),
              onTap: (){
              },
            ),
          ),
          Text(
            model.songName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "专辑《${model.album}》 歌手：${model.songAuthor}",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 64,
            padding: const EdgeInsets.only(top: 16,bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: const Icon(Icons.favorite_border),
                  backgroundColor: Colors.white.withAlpha(90),
                ),
                const SizedBox(width: 24,),
                GestureDetector(
                  child: CircleAvatar(//Play or pause
                    child: getPlayIcon(),
                    backgroundColor: Colors.white.withAlpha(90),
                  ),
                  onTap: ()=> playButtonClicked(model),
                ),
                const SizedBox(width: 24,),
                CircleAvatar(
                  child: const Icon(Icons.more_horiz),
                  backgroundColor: Colors.white.withAlpha(90),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 64),
            child: Slider(
              value: _currentSliderValue > 0 ? _currentSliderValue : 0,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _currentSliderValue = value;
                  int current = (_duration.inMilliseconds*(value/100)).round();
                  audioManager.jump(current);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    audioManager.stop();
    super.deactivate();
  }

  @override
  void dispose() {
    SongModel model = context.watch<HomePlayerModel>().current;
    audioManager.clear("${model.songName}.mp3");
    audioManager.clearCache();
    audioManager.release();
    super.dispose();
  }

  Widget getPlayIcon() {
    PlayerState state = audioManager.state();
    switch(state){
      case PlayerState.STOPPED: {
        return const Icon(Icons.play_circle_outline);
      }
      case PlayerState.PLAYING: {
        return const Icon(Icons.pause_circle_outline);
      }
      case PlayerState.PAUSED: {
        return const Icon(Icons.play_circle_outline);
      }
      case PlayerState.COMPLETED: {
        return const Icon(Icons.play_circle_outline);
      }
    }
  }

  playButtonClicked(SongModel model) {
    PlayerState state = audioManager.state();
    switch(state){
      case PlayerState.STOPPED: {
        controller.forward();
        audioManager.playLocal("${model.songName}.mp3").then((value) {
          if(value == 1) {
            setState(() {});
          }
        });
        break;
      }
      case PlayerState.PLAYING: {
        controller.stop();
        audioManager.pause();
        setState(() {});
        break;
      }
      case PlayerState.PAUSED: {
        controller.forward();
        audioManager.resume();
        setState(() {});
        break;
      }
      case PlayerState.COMPLETED: {
        controller.forward();
        audioManager.playLocal("${model.songName}.mp3");
        setState(() {});
        break;
      }
    }
  }
}


