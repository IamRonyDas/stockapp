import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:stocknews/view/detail_view.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsContainer extends StatelessWidget {
  final String imgUrl;
  final String newsHead;
  final String newsDes;
  final String newsUrl;
  final String newsCnt;

  NewsContainer({
    super.key,
    required this.imgUrl,
    required this.newsDes,
    required this.newsCnt,
    required this.newsHead,
    required this.newsUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FadeInImage.assetNetwork(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          placeholder: "assets/images/placeholder.jpeg",
          image: imgUrl,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 30),
            Text(
              newsHead.length > 90
                  ? "${newsHead.substring(0, 90)}..."
                  : newsHead,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ExpandableText(
              newsDes,
              style: TextStyle(fontSize: 12, color: Colors.black38),
              expandText: 'show more',
              collapseText: 'show less',
              maxLines: 5, // Set the number of lines before expanding
              linkColor: Colors.blue, // Color for the expand/collapse link
            ),
            SizedBox(height: 30),
            ExpandableText(
              newsCnt != "--"
                  ? newsCnt.length > 250
                      ? newsCnt.substring(0, 250)
                      : "${newsCnt.toString().substring(0, newsCnt.length)}..."
                  : newsCnt,
              style: TextStyle(fontSize: 16),
              expandText: 'read more',
              collapseText: 'read less',
              maxLines: 3, // Set the number of lines before expanding
              linkColor: Colors.blue, // Color for the expand/collapse link
            ),
          ]),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailViewScreen(newsUrl: newsUrl),
                    ),
                  );
                },
                child: Text("Read More"),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
