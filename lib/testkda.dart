import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestKda extends StatefulWidget {
  const TestKda({super.key});

  @override
  State<TestKda> createState() => _TestKdaState();
}

class _TestKdaState extends State<TestKda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white70,
        body: Center(
          child: Stack(
            children: [
              Image.network(
                  'https://th.bing.com/th/id/OIP.XU225Remieh8Qmb2HXf4AwHaEa?pid=ImgDet&rs=1',
              ),
              Positioned(
                  left: 220,
                  bottom: 80,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                //  backgroundColor: Color(0xff93D0FC),
                                content: Image.network('https://www.blackcircles.com.eg/upload/blackcircles/profiles/bc_eg/Menergysaver/xl.jpg')
                              );
                            },
                          );
                        },
                        child: const Text('1')),
                  )),
              Positioned(
                  right: 24,
                  bottom: 140,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                //  backgroundColor: Color(0xff93D0FC),
                                  content: Image.network('https://www.shorouknews.com/uploadedimages/Other/original/%D8%B4%D9%86%D8%B7%D8%A9%20777777.jpg')
                              );
                            },
                          );
                        },
                        child: const Text('2')),
                  )),
              Positioned(
                  right: 230,
                  top: 52,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                //  backgroundColor: Color(0xff93D0FC),
                                  content: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2tapXudpLM1uMk02-W-AtN-x8Lh6FzbjRi9f66h4vNw&s')
                              );
                            },
                          );
                        },

                        child: const Text('3')),
                  )),
              Positioned(
                  left: 53,
                  top: 89,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                //  backgroundColor: Color(0xff93D0FC),
                                  content: Image.network('https://media.zid.store/533b87c7-8c5f-42f1-9761-6c046b252933/427e3052-e3b6-4e85-8444-dbd383562c8d.jpg')
                              );
                            },
                          );
                        },

                        child: const Text('4')
                    ),
                  ))
            ],
          ),
        ));
  }
}
