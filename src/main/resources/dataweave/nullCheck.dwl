%dw 2.0
fun nullChars(str)=
    if (str==null or lower(str)=="null" or str=="" or str==" ") null else str