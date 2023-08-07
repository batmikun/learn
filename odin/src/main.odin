package main

import "core:fmt"

// NAMING CONVENTION

// Import name snake_case (but prefer single word)
// Types Ada_case
// Enum Values Ada_case
// Procedures snake_case
// Local variables snake_case
// Constant variabes SCREAMING_SNAKE_CASE

// odin run .-> compiles the .odin file to an executable and then runs that executable after compilation. 
// odin build <dir> -> If you do not wish to run the executable after compilation, the build command can be used
// Odin thinks in terms of directory-based packages. To tell it to treat a single file as a standalone package, add -file. odin run hellope.odin -file
main :: proc() {
  fmt.println("Hellope!")
}

// LEXICAL ELEMENTS AND LITERALS

// Comments
/*
  Can be anywhere outside of a string or character literal.
  /*
    NOTE: Multi line comments can be nested
  */

  Comments are parsed as tokens within the compiler. This is to allow for future work on automatic documentation tools.
*/

// STRING AND CHARACTER LITERALS
/*
  - String literals are enclosed in double quotes.
  - Character literals in single qoutes. 
  - Special characters are escaped with a backslash \.
  - Raw string literals are enclosed in single back ticks.
*/
str :: proc() {
  str_literal: string = "String Literal"
  char_literal: char = 'C'
  spec_chars: string = "\n"
  raw_strings: string = `Raw strings`

  len("Foo")
  len(str_literal)
}
