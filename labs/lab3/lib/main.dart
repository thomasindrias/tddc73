import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
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
        title: new Text(widget.title),
        actions: [searchBar.getSearchAction(context)]);
  }

  _MyHomePageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar);
  }

  final String languageQuery = "Flutter";

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

            if (result.loading) return Text('Loading');

            //print(result.data);
            List repositories = result.data['search']['edges']['node'];

            return ListView.builder(
                itemCount: repositories.length,
                itemBuilder: (context, index) {
                  final repository = repositories[index];

                  return Text(repository['name']);
                });
          },
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
