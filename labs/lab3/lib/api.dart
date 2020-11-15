import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> client(String authkey) => ValueNotifier(
      GraphQLClient(
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
        link: HttpLink(
            uri: 'https://api.github.com/graphql',
            headers: {"authorization": "Bearer $authkey"}),
      ),
    );

final String getTasksQuery = """
query trendingRepos(\$queryString: String!) {
  search(query: \$queryString, type: REPOSITORY, first: 40) {
    edges {
      node {
        ... on Repository {
          owner {
            avatarUrl
            url
          }
          name
          stargazers {
            totalCount
          }
          forks {
            totalCount
          }
        }
      }
    }
  }
}
""";
