import 'package:boxes/utils/api/graphql/graphql_service.dart';
import 'package:boxes/utils/app_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BaseGraphQLClient {
  BaseGraphQLClient._();

  static final BaseGraphQLClient _instance = BaseGraphQLClient._();
  static BaseGraphQLClient get instance => _instance;
  final GraphQLService _service = GraphQLService()
    ..setupClient(
        httpLink: AppConfig.instance.graphQLHttpLink,
        webSocketLink: AppConfig.instance.graphQlWebSocketLink);

  Stream<QueryResult> driveAddedSubscription(String uid) {
    String _sub = '''
    subscription{
       driveAdded(uid: "$uid"){
           id
           name
           uid
           updateTime
           accessToken
           refreshToken
           expiresIn
           scope
           driveTypeNavigation{
           id
           name
           code
        }
      }
    } ''';
    return _service.subscribe(_sub);
  }
}
