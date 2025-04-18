/**
 * German translate
 * @type Object
 */
const de = {
    btn: {
        about: 'Über',
        back: 'Zurück',
        cancel: 'Abbrechen',
        clear: 'Leeren',
        copy: 'Kopieren',
        cut: 'Ausschneiden',
        delete: 'Löschen',
        edit: 'Bearbeiten',
        forward: 'Weiter',
        folder: 'Neuer Order',
        file: 'Neue Datei',
        fullScreen: 'Vollbildschirm',
        grid: 'Raster',
        paste: 'Einfügen',
        refresh: 'Neu laden',
        submit: 'Bestätigen',
        table: 'Detailansicht',
        upload: 'Hochladen',
        uploadSelect: 'Auswählen',
        clearSelect: 'Alle ausgewählten Dateien löschen',
        hidden: ' Versteckte Dateien',
        confirm: 'Bestätigen',
    },
    clipboard: {
        actionType: 'Type',
        copy: 'Kopieren',
        cut: 'Ausschneiden',
        none: 'Nichts ausgewählt',
        title: 'Zwischenablage',
    },
    contextMenu: {
        copy: 'Kopieren',
        cut: 'Ausschneiden',
        delete: 'Löschen',
        download: 'Herunterladen',
        info: 'Ausgewählt:',
        open: 'Öffnen',
        paste: 'Einfügen',
        properties: 'Einstellungen',
        rename: 'Umbenennen',
        select: 'Wählen',
        view: 'Vorschau',
        zip: 'Zip',
        unzip: 'Unzip',
        edit: 'Bearbeiten',
        audioPlay: 'Abspielen',
        videoPlay: 'Abspielen',
    },
    info: {
        directories: 'Ordner:',
        files: 'Dateien:',
        selected: 'Ausgewählt:',
        selectedSize: 'Dateigröße:',
        size: 'Dateigröße:',
    },
    manager: {
        table: {
            date: 'Datum',
            folder: 'Ordner',
            name: 'Name',
            size: 'Größe',
            type: 'Type',
        },
    },
    modal: {
        about: {
            developer: 'Entwickler',
            name: 'Laravel File Manager',
            title: 'Über',
            version: 'Version',
        },
        delete: {
            noSelected: 'Nichts ausgewählt!',
            title: 'Löschen',
        },
        newFile: {
            fieldName: 'Dateiname',
            fieldFeedback: 'Datei existiert!',
            title: 'Neue Datei erstellen',
        },
        newFolder: {
            fieldName: 'Ordnername',
            fieldFeedback: 'Ordner existiert!',
            title: 'Neuen Ordner erstellen',
        },
        preview: {
            title: 'Vorschau',
        },
        properties: {
            disk: 'Festplatte',
            modified: 'Geändert',
            name: 'Name',
            path: 'Pfad',
            size: 'Größe',
            title: 'Eigenschaften',
            type: 'Type',
            url: 'URL',
            access: 'Zugang',
            access_0: 'Zugriff verweigert',
            access_1: 'Nur Lesezugriff',
            access_2: 'Lesen- und Schreibenzugriff',
        },
        rename: {
            directoryExist: 'Verzeichnis ist vorhanden',
            fieldName: 'Neuen Namen eingeben',
            fieldFeedback: 'Ungültiger Name',
            fileExist: 'Datei ist vorhanden',
            title: 'Umbenennen',
        },
        status: {
            noErrors: 'Keine Fehler!',
            title: 'Status',
        },
        upload: {
            ifExist: 'Datei existiert:',
            noSelected: 'Keine Dateien selektiert!',
            overwrite: 'Überschreiben!',
            selected: 'Ausgewählt:',
            size: 'Größe:',
            skip: 'Überspringen',
            title: 'Hochladen von Dateien',
        },
        editor: {
            title: 'Editor',
        },
        audioPlayer: {
            title: 'Audio-Player',
        },
        videoPlayer: {
            title: 'Video-Player',
        },
        zip: {
            title: 'Archiv erzeugen',
            fieldName: 'Archiv Name',
            fieldFeedback: 'Archiv existiert!',
        },
        unzip: {
            title: 'Archiv entpacken',
            fieldName: 'Ordnername',
            fieldRadioName: 'Extrahieren in:',
            fieldRadio1: 'Zum aktuellen Verzeichnis',
            fieldRadio2: 'In einem neuen Ordner',
            fieldFeedback: 'Ordner ist vorhanden!',
            warning: 'Achtung! Wenn die Namen übereinstimmen, werden die Dateien überschrieben!',
        },
        cropper: {
            title: 'Beschneiden',
            apply: 'Übernehmen',
            reset: 'Zurücksetzen',
            save: 'Speichern',
        },
    },
    notifications: {
        cutToClipboard: 'Ausgeschnitten in die Zwischenablage!',
        copyToClipboard: 'Kopiert in die Zwischenablage!',
    },
    response: {
        noConfig: 'Konfiguration nicht gefunden!',
        notFound: 'Nicht gefunden!',
        diskNotFound: 'Festplatte nicht gefunden!',
        pathNotFound: 'Pfad nicht gefunden!',
        diskSelected: 'Festplatte ausgewählt!',
        // files
        fileExist: 'Datei existiert bereits!',
        fileCreated: 'Datei erstellt!',
        fileUpdated: 'Datei wurde aktualisiert!',
        fileNotFound: 'Datei nicht gefunden!',
        // directories
        dirExist: 'Ordner existiert bereits!',
        dirCreated: 'Ordner angelegt!',
        dirNotFound: 'Ordner nicht gefunden',
        // actions
        uploaded: 'Alle Dateien wurden hochgeladen!',
        notAllUploaded: 'Einige Dateien wurden nicht hochgeladen!',
        delNotFound: 'Einige Dateien wurden nicht gefunden!',
        deleted: 'Gelöscht!',
        renamed: 'Umbenannt!',
        copied: 'Erfolgreich kopiert!',
        // zip
        zipError: 'Fehler bei der Erstellung des Archivs!',
        // acl
        aclError: 'Zugriff verweigert!',
    },

    clearall:{
        clear_all_selection : 'Alle Auswahl löschen',
        delete_all : 'Möchten Sie wirklich alle ausgewählten Dateien löschen?',
    }
};

export default de;
