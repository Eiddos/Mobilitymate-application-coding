import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text_google_dialog/speech_to_text_google_dialog.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText _speechToText= SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String googleResult = '';
  Color whiteColor = Color(0xfff8f7f7);
  Color mainColor = Color(0xfff00aba0);

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    print('_initSpeech');
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    print('_startListening');
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    print('_stopListening');
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    print('_onSpeechResult $result');
    print('_onSpeechResult ${result.recognizedWords}');
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobility Mate'),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  googleResult,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),

                  // _speechToText.isListening ? '$_lastWords'
                  //     : _speechEnabled
                  //     ? 'Tap the microphone to start listening...'
                  //     : 'Speech not available',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onLongPressDown: (event) {
                      _startListening;
                    },
                    onLongPressUp: () {
                      _stopListening;
                    },
                    child: FloatingActionButton(
                      // onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                      onPressed: () async {
                        bool isServiceAvailable =
                        await SpeechToTextGoogleDialog.getInstance()
                            .showGoogleDialog(onTextReceived: (data) {
                          setState(() {
                            googleResult = data.toString();
                          });
                        },

                        );
                        if (!isServiceAvailable) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Service is not available'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height - 100,
                              left: 16,
                              right: 16,
                            ),
                          ));
                        }
                      },
                      backgroundColor: mainColor,
                      child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('onLongPressDown');
                    },
                    child: FloatingActionButton(
                      onPressed: () {
                        Share.share(
                          googleResult,
                        );
                      },
                      child: Icon(Icons.send),
                      backgroundColor: mainColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed:
      //   // If not yet listening for speech start, otherwise stop
      //   _speechToText.isNotListening ? _startListening : _stopListening,
      //
      //   child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      // ),
    );
  }
}