import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whalechat/core/services/firebase/firebaseauth/authservice.dart';
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';
import 'package:whalechat/core/widgets/historycard.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:whalechat/core/widgets/loading.dart';

Widget history(BuildContext context) {
  var id =
      Provider.of<FirebaseAuthService>(context, listen: false).activeuserid;
  timeago.setLocaleMessages('tr', timeago.TrMessages());
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseUserService().getHistory(id: id),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          var model = snapshots.data.docs;
          return ListView.builder(
              itemCount: model.length,
              itemBuilder: (context, index) {
                return HistoryCard(
                    date: timeago.format(model[index].data()["date"].toDate(),
                        locale: 'tr'),
                    state: model[index].data()["state"]);
              });
        }
        return load();
      });
}
