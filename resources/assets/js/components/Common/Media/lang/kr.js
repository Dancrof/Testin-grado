/**
 * Korean translate
 * @type Object
 */
const kr = {
    btn: {
        about: '소개',
        back: '뒤로',
        cancel: '취소',
        clear: '지우기',
        copy: '복사',
        cut: '잘라내기',
        delete: '삭제',
        edit: '편집',
        forward: '앞으로',
        folder: '새 폴더',
        file: '새 파일',
        fullScreen: '전체 화면',
        grid: '격자',
        paste: '붙여넣기',
        refresh: '새로고침',
        submit: '제출',
        table: '테이블',
        upload: '업로드',
        uploadSelect: '파일 선택',
        clearSelect: '선택한 파일 지우기',
        hidden: ' 숨겨진 파일',
        confirm: '확인',
    },
    clipboard: {
        actionType: '타입',
        copy: '복사',
        cut: '잘라내기',
        none: '선택된 것 없음',
        title: '클립 보드',
    },
    contextMenu: {
        copy: '복사',
        cut: '잘라내기',
        delete: '삭제',
        download: '다운로드',
        info: '선택된 항목:',
        open: '열기',
        paste: '붙여넣기',
        properties: '속성',
        rename: '이름 바꾸기',
        select: '선택',
        view: '보기',
        zip: '압축',
        unzip: '압축 풀기',
        edit: '편집',
        audioPlay: '재생',
        videoPlay: '재생',
    },
    info: {
        directories: '폴더:',
        files: '파일:',
        selected: '선택됨:',
        selectedSize: '파일 크기:',
        size: '파일 크기:',
    },
    manager: {
        table: {
            date: '날짜',
            folder: '폴더',
            name: '이름',
            size: '크기',
            type: '타입',
        },
    },
    modal: {
        about: {
            developer: '개발자',
            name: 'Laravel 파일 관리자',
            title: '정보',
            version: '버전',
        },
        delete: {
            noSelected: '선택된 것 없음!',
            title: '삭제',
        },
        newFile: {
            fieldName: '파일 이름',
            fieldFeedback: '파일이 이미 존재합니다!',
            title: '새 파일 만들기',
        },
        newFolder: {
            fieldName: '폴더 이름',
            fieldFeedback: '폴더가 이미 존재합니다!',
            title: '새 폴더 만들기',
        },
        preview: {
            title: '미리보기',
        },
        properties: {
            disk: '디스크',
            modified: '수정됨',
            name: '이름',
            path: '경로',
            size: '크기',
            title: '속성',
            type: '타입',
            url: 'URL',
            access: '액세스',
            access_0: '액세스 거부됨',
            access_1: '읽기 전용',
            access_2: '읽기 및 쓰기',
        },
        rename: {
            directoryExist: '폴더가 이미 존재합니다',
            fieldName: '새 이름 입력',
            fieldFeedback: '잘못된 이름',
            fileExist: '파일이 이미 존재합니다',
            title: '이름 변경',
        },
        status: {
            noErrors: '오류 없음!',
            title: '상태',
        },
        upload: {
            ifExist: '파일이 이미 있는 경우:',
            noSelected: '선택된 파일 없음!',
            overwrite: '덮어쓰기!',
            selected: '선택됨:',
            size: '크기:',
            skip: '건너뛰기',
            title: '파일 업로드',
        },
        editor: {
            title: '편집기',
        },
        audioPlayer: {
            title: '오디오 플레이어',
        },
        videoPlayer: {
            title: '비디오 플레이어',
        },
        zip: {
            title: '압축 파일 만들기',
            fieldName: '압축 파일 이름',
            fieldFeedback: '압축 파일이 이미 존재합니다!',
        },
        unzip: {
            title: '압축 해제',
            fieldName: '폴더 이름',
            fieldRadioName: '다음 위치에 추출:',
            fieldRadio1: '현재 폴더로',
            fieldRadio2: '새 폴더로',
            fieldFeedback: '폴더가 이미 존재합니다!',
            warning: '주의! 이름이 일치하는 경우 파일이 덮어씌워집니다!',
        },
        cropper: {
            title: '자르기',
            apply: '적용',
            reset: '초기화',
            save: '저장',
        },
    },
    notifications: {
        cutToClipboard: '클립보드로 잘라내기!',
        copyToClipboard: '클립보드로 복사!',
    },
    response: {
        noConfig: '구성을 찾을 수 없습니다!',
        notFound: '찾을 수 없습니다!',
        diskNotFound: '디스크를 찾을 수 없습니다!',
        pathNotFound: '경로를 찾을 수 없습니다!',
        diskSelected: '디스크 선택됨!',
        // files
        fileExist: '파일이 이미 존재합니다!',
        fileCreated: '파일이 생성되었습니다!',
        fileUpdated: '파일이 업데이트되었습니다!',
        fileNotFound: '파일을 찾을 수 없습니다!',
        // directories
        dirExist: '폴더가 이미 존재합니다!',
        dirCreated: '폴더가 생성되었습니다!',
        dirNotFound: '폴더를 찾을 수 없습니다',
        // actions
        uploaded: '모든 파일이 업로드되었습니다!',
        notAllUploaded: '일부 파일이 업로드되지 않았습니다!',
        delNotFound: '일부 항목을 찾을 수 없습니다!',
        deleted: '삭제되었습니다!',
        renamed: '이름이 변경되었습니다!',
        copied: '성공적으로 복사되었습니다!',
        // zip
        zipError: '아카이브 생성 오류!',
        // acl
        aclError: '액세스 거부됨!',
    },

    clearall:{
        clear_all_selection : '모든 선택 지우기',
        delete_all : '정말 선택한 모든 파일을 지우시겠습니까?',
    }
};

export default kr;
