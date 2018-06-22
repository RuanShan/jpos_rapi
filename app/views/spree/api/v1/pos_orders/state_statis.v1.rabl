@state_statis.each_pair{|key,val|
  node(key) { val }
}
