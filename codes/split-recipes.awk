BEGIN{
    RS="\r?\n\r?\n(\r?\n)+"
    FS="\r?\n\r?\n"
    OFS= "\n" 
} 
/^\[[0-9]+\]/{
    gsub("[ ]*\r?\n[ ]*", " - ", $1)

    gsub("\r?\n", " ", $2)

    gsub(" \\[[0-9]+\\]", "", $1)
    gsub(" \\[[0-9]+\\]", "", $2)

    OUTPUTFILE = "data/apicius/recipes/" $1 ".txt"
    print $2 > OUTPUTFILE
}