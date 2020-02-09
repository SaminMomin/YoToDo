class Item{
  int _id;
  String _title;
  String _content;
  String _date;
  
  Item(this._title,this._content,this._date);
  Item.map(dynamic obj){
    this._title=obj['title'];
    this._content=obj['content'];
    this._date=obj['date'];
    this._id=obj['id'];
  }
  get id=>_id;
  get title=>_title;
  get content=>_content;
  get date=>_date;  
  
  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map['title']=this._title;
    map['content']=this._content;
    map['date']=this._date;
    if(id!=null){
      map['id']=this._id;
    }
    return map;
  }

  Item.fromMap(Map<String,dynamic> item){
    this._id=item['id'];
    this._title=item['title'];
    this._content=item['content'];
    this._date=item['date'];
  }
}