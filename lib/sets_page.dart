import 'package:flutter/material.dart';
import 'package:kitahack_hackathon/loading_page.dart';
import 'textstyles.dart';
import 'colours.dart';

class SetsPage extends StatefulWidget {
  final dynamic backend;
  final Function refresh;
  const SetsPage({super.key, required this.backend, required this.refresh});

  @override
  State<SetsPage> createState() => _SetsPageState();
}

class _SetsPageState extends State<SetsPage> {
  @override
  Widget build(BuildContext context) {
    int latestSet = widget.backend.userInfo["latest_set"];
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 50, left: 10, right: 10),
        color: offWhite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Positioned(
                    left: 20,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.keyboard_return_rounded),
                    ),
                  ),
                  Center(child: Text('Choose A Set', style: defaultText)),
                  Positioned(
                    right: 20,
                    bottom: 5,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => LoadingPage(
                                  backend: widget.backend,
                                  redrawPage: widget.refresh,
                                ),
                          ),
                        );
                      },
                      child: Icon(Icons.add_circle_rounded),
                    ),
                  ),
                ],
              ),

              for (int i = 1; i <= latestSet; i++)
                SetBox(
                  setNum: i,
                  backend: widget.backend,
                  refresh: widget.refresh,
                ),
              SizedBox(width: double.infinity, height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class SetBox extends StatelessWidget {
  final int setNum;
  final dynamic backend;
  final Function refresh;

  const SetBox({
    required this.setNum,
    super.key,
    required this.backend,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30, width: double.maxFinite),
        GestureDetector(
          onTap: () {
            backend.updateCurrSet(setNum);
            backend.userInfoRetrieved = false;
            refresh();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0x99000abc),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(child: Text("Set $setNum", style: whiteDefaultText)),
          ),
        ),
      ],
    );
  }
}
