import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:half/services/cloudFirestore.dart';

class DataLists {
  //Mechanics: Get relationship data
  String getRelationshipData(int position) {
    List<String> _relationshipList = getRelationshipList();
    return _relationshipList[position];
  }

  //Mechanics: Get relationship list
  List<String> getRelationshipList() {
    List<String> _relationshipList = new List<String>();
    _relationshipList.add("Single");
    _relationshipList.add("Talking");
    _relationshipList.add("Dating");
    _relationshipList.add("Married");
    return _relationshipList;
  }
}