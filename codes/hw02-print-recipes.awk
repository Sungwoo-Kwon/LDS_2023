BEGIN {
    RS = "\r?\n\r?\n(\r?\n)+"   # 레시피를 분리할 레코드 구분자 정의
    FS = "\r?\n(\r?\n)+"       # 레시피 내에서 필드를 분리할 필드 구분자 정의
}

/^\[[0-9]+\]/ {
    if (recipe_number != "") {
        # 현재 처리 중인 레시피를 출력합니다.
        printf "[%s] %s\n%s\n%s\n\n", recipe_number, english_title, latin_title, recipe_content
    }

    gsub("[ \n]\\[[0-9]+\\]", "", $0)  # 영어 레시피 이름에서 주석 번호 제거
    gsub("_\\[[0-9]+\\]_", "", $0)      # 라틴어 레시피 이름에서 주석 번호 제거

    # 레시피 번호와 제목을 추출하여 저장
    recipe_number = $0
    getline                      # 라틴어 제목을 읽기 위해 다음 라인으로 이동
    latin_title = $0
    getline                      # 영어 제목을 읽기 위해 다음 라인으로 이동
    english_title = $0

    # 새 레시피를 시작하기 전에 초기화합니다.
    recipe_content = ""
}

{
    if ($0 !~ /^CHAP\.\s[IVXLCDM]+\s/) {
        # 레시피 내용을 1개의 행으로 합칩니다.
        recipe_content = recipe_content $0 " "
    }
    
    # 라틴어 이름에서 양쪽 밑줄 (_)를 제거합니다.
    gsub("_", "", latin_title)
}

END {
    if (recipe_number != "") {
        # 마지막 레시피를 출력합니다.
        printf "[%s] %s\n%s\n%s\n", recipe_number, english_title, latin_title, recipe_content
    }
}



