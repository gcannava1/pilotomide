//Trim
String.prototype.trimLeft =function(){
  return this.replace(/^\s*/,"");
}

String.prototype.trimRight =function(){
  return this.replace(/\s*$/,"");
}

String.prototype.trim =function(){
  return this.trimRight().trimLeft();
}

String.prototype.trimAll =function(){
  return this.replace(/[ ]+/g,"");
}


