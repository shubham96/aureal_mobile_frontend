import 'package:auditory/utilities/SizeConfig.dart';
import 'package:flutter/material.dart';

class Seekbar extends StatefulWidget {
  Duration currentPosition;
  Duration duration;
  String episodeName;
  final Function(Duration) seekTo;

  Seekbar(
      {@required this.currentPosition,
      @required this.duration,
      @required this.episodeName,
      @required this.seekTo});

  @override
  _SeekbarState createState() => _SeekbarState();
}

class _SeekbarState extends State<Seekbar> {
  String changingDuration = '0.0';

  void durationToString(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes =
        twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds =
        twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));

    setState(() {
      changingDuration = "$twoDigitMinutes:$twoDigitSeconds";
    });
  }

  Duration _visibleValue;
  bool listenOnlyUserInteraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(Seekbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInteraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
              trackHeight: 3,
             // activeTrackColor: Color(0xff212121),
              //    inactiveTrackColor: Colors.black,
                thumbColor: Colors.blue,
              thumbShape: SliderComponentShape.noThumb
              // thumbShape: RoundSliderThumbShape(
              //     pressedElevation: 1.0,
              //     enabledThumbRadius: 8,
              //     disabledThumbRadius: 5),
              ),
          child: Slider(
            min: 0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: percent * widget.duration.inMilliseconds.toDouble(),
            onChangeEnd: (newValue) {
              setState(() {
                listenOnlyUserInteraction = false;
                widget.seekTo(_visibleValue);
              });
            },
            onChangeStart: (_) {
              setState(() {
                listenOnlyUserInteraction = true;
              });
            },
            onChanged: (newValue) {
              setState(() {
                final to = Duration(milliseconds: newValue.floor());
                _visibleValue = to;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.currentPosition.toString().split('.')[0],
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: 8),
              ),
              SizedBox(
                width: 230,
                child: Text(
                  widget.episodeName,
                  textScaleFactor: 1.0,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  // textWidthBasis: TextWidthBasis.longestLine,
                  style: TextStyle(
                      //   color: Colors.white,
                      fontSize: SizeConfig.safeBlockHorizontal * 3),
                ),
              ),
              Text(
                widget.duration.toString().split('.')[0],
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: 8),
              )
            ],
          ),
        )
      ],
    );
  }
}
