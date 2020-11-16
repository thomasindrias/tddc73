import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lab3/Repo.dart';
import 'package:lab3/RepoDetail.dart';

import 'api.dart';

Future main() async {
  // load environment variable
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String authKey = DotEnv().env['GITHUB_PERSONAL_KEY'];
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client(authKey),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Trending Repos'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text("Trending Repos: $languageQuery"),
        actions: [searchBar.getSearchAction(context)]);
  }

  _MyHomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: (String value) {
          setState(() {
            languageQuery = value;
          });
        },
        buildDefaultAppBar: buildAppBar);
  }

  Repo generateRepoObj(objectItem) {
    String title = objectItem["name"];
    String owner = objectItem["owner"]["login"];
    String img = objectItem["owner"]["avatarUrl"];
    String description = objectItem["description"];
    int forks = objectItem["forks"]["totalCount"];
    int stargazers = objectItem["stargazers"]["totalCount"];
    int watchers = objectItem["watchers"]["totalCount"];

    return new Repo(
        title, owner, img, description, forks, stargazers, watchers);
  }

  String languageQuery = "Dart";
  ScrollController _scrollController = new ScrollController();
  //final languageController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Query(
        options: QueryOptions(
          documentNode: gql(getTasksQuery),
          variables: {'queryString': 'language:$languageQuery stars:>1000'},
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) return Text(result.exception.toString());

          if (result.loading)
            return Center(
                child: Container(
              child: CircularProgressIndicator(),
            ));

          final Map pageInfo = result.data['search']['pageInfo'];
          final String fetchMoreCursor = pageInfo['endCursor'];

          FetchMoreOptions opts = FetchMoreOptions(
            variables: {'cursor': fetchMoreCursor},
            updateQuery: (previousResultData, fetchMoreResultData) {
              // this function will be called so as to combine both the original and fetchMore results
              // it allows you to combine them as you would like
              final List<dynamic> repos = [
                ...previousResultData['search']['nodes'] as List<dynamic>,
                ...fetchMoreResultData['search']['nodes'] as List<dynamic>
              ];

              // to avoid a lot of work, lets just update the list of repos in returned
              // data with new data, this also ensures we have the endCursor already set
              // correctly
              fetchMoreResultData['search']['nodes'] = repos;

              return fetchMoreResultData;
            },
          );

          _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
              fetchMore(opts);
            }
          });

          //print(result.data);
          List<Repo> repositories = new List();
          for (var repository in result.data['search']['nodes']) {
            repositories.add(generateRepoObj(repository));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: repositories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == repositories.length)
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RaisedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Load More"),
                                ],
                              ),
                              onPressed: () {
                                fetchMore(opts);
                              },
                            ),
                          ),
                        );

                      final repository = repositories[index];
                      return Card(
                        margin: EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RepoDetail(repository)));
                          },
                          child: ListTile(
                              title: Text(repository.title),
                              subtitle: Text(
                                repository.description,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Container(
                                width: 80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.star_border,
                                      size: 18,
                                      color: Colors.orange,
                                    ),
                                    Flexible(
                                      child: Text(
                                          repository.stargazers.toString(),
                                          style:
                                              TextStyle(color: Colors.black)),
                                    )
                                  ],
                                ),
                              ),
                              leading: Tab(
                                icon: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl: repository.img,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              )),
                        ),
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
