// ignore_for_file: file_names, prefer_const_constructors, unused_local_variable

import 'package:crm_client/Chat/chat_screen.dart';
import 'package:crm_client/Invoices/invoices_screen.dart';
import 'package:crm_client/Profile/editProfile.dart';
import 'package:crm_client/Project/Project_Detail_Tabs/discussView.dart';
import 'package:crm_client/Project/Project_Detail_Tabs/project_AddTicket.dart';
import 'package:crm_client/Project/project_detail_screen.dart';
import 'package:crm_client/Project/project_screen.dart';
import 'package:crm_client/Proposals/ProposalView.dart';
import 'package:crm_client/Proposals/proposal_screen.dart';
import 'package:crm_client/SignInScreen.dart';
import 'package:crm_client/Support/add_ticket_screen.dart';
import 'package:crm_client/Contracts/contracts_screen.dart';
import 'package:crm_client/Dashboard/dashboard_screen.dart';
import 'package:crm_client/Estimates/estimates_screen.dart';
import 'package:crm_client/Support/support_screen.dart';
import 'package:crm_client/Support/ticket_details_screen.dart';
import 'package:crm_client/Profile/profile.dart';
import 'package:crm_client/bottom_Navigation_bar.dart';
import 'package:crm_client/splashWidget.dart';
import 'package:flutter/material.dart';

import '../Chat/clientlisting.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case SplashWidget.id:
        return MaterialPageRoute(builder: (_) => SplashWidget());
      case BottomBar.id:
        return MaterialPageRoute(builder: (_) => BottomBar());
      case SignInScreen.id:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case AddTicket.id:
        return MaterialPageRoute(builder: (_) => AddTicket());
      case ContractsScreen.id:
        return MaterialPageRoute(builder: (_) => ContractsScreen());
      case DashBoardScreen.id:
        return MaterialPageRoute(builder: (_) => DashBoardScreen());
      case TicketDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => TicketDetailScreen(
                  data: args as PassTicketData,
                ));
      case EstimatesScreen.id:
        return MaterialPageRoute(builder: (_) => EstimatesScreen());
      case InvoicesScreen.id:
        return MaterialPageRoute(builder: (_) => InvoicesScreen());
      case ProjectScreen.id:
        return MaterialPageRoute(builder: (_) => ProjectScreen());
      case SupportScreen.id:
        return MaterialPageRoute(builder: (_) => SupportScreen());
      case ProjectDetailScreen.id:
        return MaterialPageRoute(
            builder: (_) => ProjectDetailScreen(data: args as PassData));
      case ProjectAddTicket.id:
        return MaterialPageRoute(
            builder: (_) => ProjectAddTicket(data: args as PassData));
      case Profile.id:
        return MaterialPageRoute(builder: (_) => Profile());
      case clientlisting.id:
        return MaterialPageRoute(builder: (_) => clientlisting());
      case Chat_Screen.id:
        return MaterialPageRoute(
            builder: (_) => Chat_Screen(
                  passdata: args as chatdata,
                ));
      case EditProfile.id:
        return MaterialPageRoute(builder: (_) => EditProfile());
      case ProposalsScreen.id:
        return MaterialPageRoute(builder: (_) => ProposalsScreen());
      case ProposalView.id:
        return MaterialPageRoute(
            builder: (_) => ProposalView(webdata: args as PassData));
      case DiscussView.id:
        return MaterialPageRoute(
            builder: (_) => DiscussView(
                  data: args as List,
                ));

      default:
        //    If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Page Note Found'),
        ),
      );
    });
  }
}
