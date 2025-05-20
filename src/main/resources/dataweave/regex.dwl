%dw 2.0
fun escapeSingleQuote(str: String) =
    str replace "'" with "\'"
fun nullChars(str)=
    if ( str==null or lower(str)=="null" or str=="" or str==" " ) null else str
fun phoneCheck(data) =
 if ( data is Array ) data
 else if ( data startsWith "[" ) data replace "[" with "" replace "]" with "" splitBy "," map (item) -> trim(item) replace "'" with ""
 else data
fun emailReplace(p) = do {
  var a = (p splitBy ".")
  ---
  if ((p contains ('@')) or nullChars(p)==null)
    nullChars(p)
  else
    ((a[0 to -3] joinBy ".") default "xyz") ++ "@" ++ (a[-2] default "") ++ "." ++ (a[-1] default "")
}