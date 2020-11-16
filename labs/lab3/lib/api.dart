import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

ValueNotifier<GraphQLClient> client(String authkey) => ValueNotifier(
      GraphQLClient(
        cache:
            NormalizedInMemoryCache(dataIdFromObject: typenameDataIdFromObject),
        link: HttpLink(
            uri: 'https://api.github.com/graphql',
            headers: {"authorization": "Bearer $authkey"}),
      ),
    );

final String getTasksQuery = """
query trendingRepos(\$queryString: String!, \$cursor: String) {
  search(query: \$queryString, type: REPOSITORY, first: 10, after: \$cursor) {
    pageInfo {
      endCursor
      hasNextPage
      hasPreviousPage
      startCursor
    }
    nodes {
      ... on Repository {
        id
        name
        owner {
          avatarUrl
          url
        }
        stargazers {
          totalCount
        }
        forks {
          totalCount
        }
        description
      }
    }
  }
}
""";
