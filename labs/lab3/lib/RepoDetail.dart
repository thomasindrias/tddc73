import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab3/Repo.dart';

class RepoDetail extends StatelessWidget {
  final Repo repo;

  RepoDetail(this.repo);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text(repo.title)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            Container(
              height: height * 0.3,
              child: Center(
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: repo.img,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Icon(
                                  FontAwesomeIcons.star,
                                  size: 24,
                                  color: Colors.orange,
                                ),
                              ),
                              Container(
                                child: Text(repo.stargazers.toString(),
                                    style: TextStyle(color: Colors.black)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Icon(
                                  FontAwesomeIcons.codeBranch,
                                  size: 24,
                                ),
                              ),
                              Container(
                                child: Text(repo.forks.toString(),
                                    style: TextStyle(color: Colors.black)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Icon(
                                  FontAwesomeIcons.eye,
                                  size: 24,
                                ),
                              ),
                              Container(
                                child: Text(repo.watchers.toString(),
                                    style: TextStyle(color: Colors.black)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Container(),
                  ),
                  Text(repo.title ?? 'No title',
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 26, fontWeight: FontWeight.bold)),
                  Text(repo.owner ?? 'No name',
                      style: GoogleFonts.sourceSansPro(fontSize: 24)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      child: Text(repo.description ?? 'No description',
                          style: GoogleFonts.sourceSansPro(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
