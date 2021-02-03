
class Message {
  String direction;
  String receiver;
  String sender;
  String sms_id;
  String status;
  String text;
  String timestamp;
  int id;

// When we handle simple text
  Message({
    this.sender, 
    this.receiver, 
    this.direction,
    this.sms_id, 
    this.timestamp,
    this.status,
    this.text,
    // this.id
    });

  Map toMap() {
    var map = {
      'direction': direction,
      'receiver': receiver,
      'sender': sender,
      'sms_id': sms_id,
      'status': status,
      'text': text,
      'timestamp': timestamp,
      // 'id': id,
    };
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.direction = map['direction'];
    this.receiver = map['receiver'];
    // TODO: Response has been changed in server for send message function only.
    // Need to implement a condition for map['sender']['phone_number']
    if(map['sender'] is String){
      this.sender = map['sender'];
    }
    else{
      this.sender = map['sender']['phone_number'];
    }
    this.sms_id = map['sms_id'];
    this.status = map['status'];
    this.text = map['text'];
    this.timestamp = map['timestamp'];
    // this.id = map['id'];
  }
}