class Chat {
  String id, creator, name;
  List<String> tags, members;

  Chat(String id, String creator, String name, List<String> tags, List<String> members) {
    this.id = id;
    this.creator = creator;
    this.name = name;
    this.tags = tags;
    this.members = members;
  }
}

