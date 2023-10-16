BEGIN { RS = "" }
{
  recipe_number = $1
  english_name = $2
  latin_name = $3
  gsub("_", " ", latin_name)  # Remove underscores from the Latin name

  # Start at the 4th field and join the lines of the recipe
  recipe = ""
  for (i = 4; i <= NF; i++) {
    recipe = recipe " " $i
  }
  gsub("\n", " ", recipe)  # Remove newline characters within the recipe

  # Print the formatted block for each dish
  printf "[%s] %s\n%s\n%s\n", recipe_number, english_name, latin_name, recipe

  # Separate each block with two newline characters
  print ""
}