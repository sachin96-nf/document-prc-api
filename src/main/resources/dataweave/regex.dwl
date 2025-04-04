%dw 2.0
fun escapeSingleQuote(str: String) =
    str replace "'" with "\'"