# 권성우 (KWON SUNGWOO) 2023-82030
# 제 개인적인 해석을 많이 추가하였습니다. 결과가 정확하지는 않습니다.

BEGIN {
    RS = "\r?\n\r?\n(\r?\n)+"   
    FS = "\r?\n(\r?\n)+"       
}

/^\[[0-9]+\]/ {
    if (recipe_number != "") {
        printf "[%s] %s\n%s\n%s\n\n", recipe_number, english_title, latin_title, recipe_content
    }

    gsub("[ \n]\\[[0-9]+\\]", "", $0)  
    gsub("_\\[[0-9]+\\]_", "", $0)      

    
    recipe_number = $0
    getline                      
    latin_title = $0
    getline                      
    english_title = $0

   
    recipe_content = ""
}

{
    if ($0 !~ /^CHAP\.\s[IVXLCDM]+\s/) {
        
        recipe_content = recipe_content $0 " "
    }
    
    
    gsub("_", "", latin_title)
}

END {
    if (recipe_number != "") {
        
        printf "[%s] %s %s\n%s\n\n", recipe_number, english_title, latin_title, recipe_content
    }
}