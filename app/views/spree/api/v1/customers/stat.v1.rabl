@statistics.each_pair{|key,val|
  node(key) { val }
}
