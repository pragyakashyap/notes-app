class NoteForListing{
  String id;
  String title;
  String content;

  NoteForListing({
    this.id,
    this.title,
    this.content,
  });

  factory NoteForListing.fromjson(Map<String,dynamic> item){
           return NoteForListing(
            id: item['id'],
            title: item['title'],
            content:item['content'],
          );
  }

  
}