import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:random_user/dio_settings.dart';
import 'package:random_user/random_user_model.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<RandomUserModel> getUserData() async {
    final Dio dio = DioSettings().dio;
    final Response response = await dio.get("https://randomuser.me/api/");
    return RandomUserModel.fromJson(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff68b1c9),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: const Text(
                    "Generate",
                    style: TextStyle(
                      color: Color(0xff0042EB),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                // в snapshot хранится вся информация относительно нашего Future (getUserData())
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 148,
                            backgroundImage: NetworkImage(
                              snapshot.data?.results?.first.picture?.medium ??
                                  '',
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          InfoContainer(
                            title: "Name",
                            data: "${snapshot.data?.results![0].name?.title} ${snapshot.data?.results![0].name?.first} ${snapshot.data?.results![0].name?.last}",
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InfoContainer(
                            title: "Username",
                            data: "${snapshot.data?.results![0].login?.username}",
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InfoContainer(
                            title: "Phone number",
                            data: "${snapshot.data?.results![0].phone}",
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InfoContainer(
                            title: "Email",
                            data: "${snapshot.data?.results![0].email}",
                          ),
                        ],
                      ),
                    );
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            const Spacer(), // Добавленный Spacer для выравнивания внизу
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: ElevatedButton(
                onPressed: () async {
                  final userData = await getUserData();
                  launchUrl(
                    Uri.parse(
                      "https://maps.google.com/?q=${userData.results?.first.location?.coordinates?.latitude},${userData.results?.first.location?.coordinates?.longitude}",
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff263775),
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.9, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text(
                  "Get Location",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  final String title;
  final String data;
  const InfoContainer({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xfff4f4f4),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
        border: Border(
            bottom: BorderSide(
          width: 1,
        )),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff4f4f51),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  data,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
