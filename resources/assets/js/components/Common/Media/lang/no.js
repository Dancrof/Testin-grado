/**
 * Norwegian Translate
 * @type Object
 */
const no = {
    btn: {
        about: 'Om',
        back: 'Tilbake',
        cancel: 'Avbryt',
        clear: 'Tøm',
        copy: 'Kopier',
        cut: 'Klipp ut',
        delete: 'Slett',
        edit: 'Rediger',
        forward: 'Fremover',
        folder: 'Ny mappe',
        file: 'Ny fil',
        fullScreen: 'Fullskjerm',
        grid: 'Rutenett',
        paste: 'Lim inn',
        refresh: 'Oppdater',
        submit: 'Send inn',
        table: 'Tabell',
        upload: 'Last opp',
        uploadSelect: 'Velg filer',
        clearSelect: 'Fjern all valgte filer',
        hidden: ' Skjulte filer',
        confirm: 'Bekreft',
    },
    clipboard: {
        actionType: 'Type',
        copy: 'Kopier',
        cut: 'Klipp ut',
        none: 'Ingenting valgt',
        title: 'Utklippstavle',
    },
    contextMenu: {
        copy: 'Kopier',
        cut: 'Klipp ut',
        delete: 'Slett',
        download: 'Last ned',
        info: 'Valgt:',
        open: 'Åpne',
        paste: 'Lim inn',
        properties: 'Egenskaper',
        rename: 'Gi nytt navn',
        select: 'Velg',
        view: 'Vis',
        zip: 'Zip',
        unzip: 'Unzip',
        edit: 'Rediger',
        audioPlay: 'Spill av',
        videoPlay: 'Spill av',
    },
    info: {
        directories: 'Mapper:',
        files: 'Filer:',
        selected: 'Valgt:',
        selectedSize: 'Filstørrelse:',
        size: 'Filstørrelse:',
    },
    manager: {
        table: {
            date: 'Dato',
            folder: 'Mappe',
            name: 'Navn',
            size: 'Størrelse',
            type: 'Type',
        },
    },
    modal: {
        about: {
            developer: 'Utvikler',
            name: 'Laravel Filbehandler',
            title: 'Om',
            version: 'Versjon',
        },
        delete: {
            noSelected: 'Ingenting valgt!',
            title: 'Slett',
        },
        newFile: {
            fieldName: 'Filnavn',
            fieldFeedback: 'Filen eksisterer allerede!',
            title: 'Opprett ny fil',
        },
        newFolder: {
            fieldName: 'Mappenavn',
            fieldFeedback: 'Mappen eksisterer allerede!',
            title: 'Opprett ny mappe',
        },
        preview: {
            title: 'Forhåndsvisning',
        },
        properties: {
            disk: 'Disk',
            modified: 'Endret',
            name: 'Navn',
            path: 'Sti',
            size: 'Størrelse',
            title: 'Egenskaper',
            type: 'Type',
            url: 'URL',
            access: 'Tilgang',
            access_0: 'Tilgang nektet',
            access_1: 'Bare lese',
            access_2: 'Les og skriv',
        },
        rename: {
            directoryExist: 'Mappen eksisterer allerede',
            fieldName: 'Skriv inn nytt navn',
            fieldFeedback: 'Ugyldig navn',
            fileExist: 'Filen eksisterer allerede',
            title: 'Gi nytt navn',
        },
        status: {
            noErrors: 'Ingen feil!',
            title: 'Status',
        },
        upload: {
            ifExist: 'Hvis filen allerede eksisterer:',
            noSelected: 'Ingen filer valgt!',
            overwrite: 'Overskriv!',
            selected: 'Valgt:',
            size: 'Størrelse:',
            skip: 'Hopp over',
            title: 'Last opp filer',
        },
        editor: {
            title: 'Rediger',
        },
        audioPlayer: {
            title: 'Lydavspiller',
        },
        videoPlayer: {
            title: 'Videospiller',
        },
        zip: {
            title: 'Opprett arkiv',
            fieldName: 'Arkivnavn',
            fieldFeedback: 'Arkivet eksisterer allerede!',
        },
        unzip: {
            title: 'Pakk ut arkiv',
            fieldName: 'Mappenavn',
            fieldRadioName: 'Pakk ut til:',
            fieldRadio1: 'Til gjeldende mappe',
            fieldRadio2: 'I en ny mappe',
            fieldFeedback: 'Mappen eksisterer allerede!',
            warning: 'Advarsel! Hvis navnene matcher, vil filene bli overskrevet!',
        },
        cropper: {
            title: 'Beskjæring',
            apply: 'Bruk',
            reset: 'Tilbakestill',
            save: 'Lagre',
        },
    },
    notifications: {
        cutToClipboard: 'Klippet til utklippstavlen!',
        copyToClipboard: 'Kopiert til utklippstavlen!',
    },
    response: {
        noConfig: 'Konfigurasjon ikke funnet!',
        notFound: 'Ikke funnet!',
        diskNotFound: 'Disk ikke funnet!',
        pathNotFound: 'Sti ikke funnet!',
        diskSelected: 'Disk valgt!',
        // files
        fileExist: 'Filen eksisterer allerede!',
        fileCreated: 'Fil opprettet!',
        fileUpdated: 'Fil oppdatert!',
        fileNotFound: 'Filen ble ikke funnet!',
        // directories
        dirExist: 'Mappen eksisterer allerede!',
        dirCreated: 'Mappe opprettet!',
        dirNotFound: 'Mappen ble ikke funnet',
        // actions
        uploaded: 'Alle filer lastet opp!',
        notAllUploaded: 'Noen filer ble ikke lastet opp!',
        delNotFound: 'Noen elementer ble ikke funnet!',
        deleted: 'Slettet!',
        renamed: 'Navn endret!',
        copied: 'Kopiert vellykket!',
        // zip
        zipError: 'Feil ved oppretting av arkiv!',
        // acl
        aclError: 'Tilgang nektet!',
    },

    clearall:{
        clear_all_selection : 'Fjern all valg',
        delete_all : 'Vil du virkelig slette alle valgte filer?',
    }
};

export default no;
