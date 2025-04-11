/**
 * Bosnian English translate
 * @type Object
 */
const bsn = {
    btn: {
        about: 'O nama',
        back: 'Nazad',
        cancel: 'Otkaži',
        clear: 'Očisti',
        copy: 'Kopiraj',
        cut: 'Izreži',
        delete: 'Obriši',
        edit: 'Uredi',
        forward: 'Naprijed',
        folder: 'Nova mapa',
        file: 'Nova datoteka',
        fullScreen: 'Puni ekran',
        grid: 'Mreža',
        paste: 'Zalijepi',
        refresh: 'Osvježi',
        submit: 'Potvrdi',
        table: 'Tabela',
        upload: 'Učitaj',
        uploadSelect: 'Odaberi datoteke',
        clearSelect: 'Očisti sve odabrane datoteke',
        hidden: ' Skrivene datoteke',
        confirm: 'Potvrdi',
    },
    clipboard: {
        actionType: 'Tip',
        copy: 'Kopiraj',
        cut: 'Izreži',
        none: 'Ništa nije odabrano',
        title: 'Clipboard',
    },
    contextMenu: {
        copy: 'Kopiraj',
        cut: 'Izreži',
        delete: 'Obriši',
        download: 'Preuzmi',
        info: 'Odabrano:',
        open: 'Otvori',
        paste: 'Zalijepi',
        properties: 'Svojstva',
        rename: 'Preimenuj',
        select: 'Odaberi',
        view: 'Pogled',
        zip: 'Zip',
        unzip: 'Otpakuj',
        edit: 'Uredi',
        audioPlay: 'Reproduciraj',
        videoPlay: 'Reproduciraj',
    },
    info: {
        directories: 'Mape:',
        files: 'Datoteke:',
        selected: 'Odabrano:',
        selectedSize: 'Veličina datoteka:',
        size: 'Veličina datoteka:',
    },
    manager: {
        table: {
            date: 'Datum',
            folder: 'Mapa',
            name: 'Naziv',
            size: 'Veličina',
            type: 'Tip',
        },
    },
    modal: {
        about: {
            developer: 'Razvijatelj',
            name: 'Laravel File Manager',
            title: 'O nama',
            version: 'Verzija',
        },
        delete: {
            noSelected: 'Ništa nije odabrano!',
            title: 'Obriši',
        },
        newFile: {
            fieldName: 'Naziv datoteke',
            fieldFeedback: 'Datoteka već postoji!',
            title: 'Kreiraj novu datoteku',
        },
        newFolder: {
            fieldName: 'Naziv mape',
            fieldFeedback: 'Mapa već postoji!',
            title: 'Kreiraj novu mapu',
        },
        preview: {
            title: 'Pregled',
        },
        properties: {
            disk: 'Disk',
            modified: 'Izmijenjeno',
            name: 'Naziv',
            path: 'Putanja',
            size: 'Veličina',
            title: 'Svojstva',
            type: 'Tip',
            url: 'URL',
            access: 'Pristup',
            access_0: 'Pristup odbijen',
            access_1: 'Samo čitanje',
            access_2: 'Čitanje i pisanje',
        },
        rename: {
            directoryExist: 'Mapa već postoji',
            fieldName: 'Unesite novi naziv',
            fieldFeedback: 'Nevažeći naziv',
            fileExist: 'Datoteka već postoji',
            title: 'Preimenuj',
        },
        status: {
            noErrors: 'Nema grešaka!',
            title: 'Status',
        },
        upload: {
            ifExist: 'Ako datoteka postoji:',
            noSelected: 'Nisu odabrane datoteke!',
            overwrite: 'Prepiši!',
            selected: 'Odabrano:',
            size: 'Veličina:',
            skip: 'Preskoči',
            title: 'Učitaj datoteke',
        },
        editor: {
            title: 'Editor',
        },
        audioPlayer: {
            title: 'Audio player',
        },
        videoPlayer: {
            title: 'Video player',
        },
        zip: {
            title: 'Kreiraj arhivu',
            fieldName: 'Naziv arhive',
            fieldFeedback: 'Arhiva već postoji!',
        },
        unzip: {
            title: 'Raspakuj arhivu',
            fieldName: 'Naziv mape',
            fieldRadioName: 'Izvuci u:',
            fieldRadio1: 'U trenutnu mapu',
            fieldRadio2: 'U novu mapu',
            fieldFeedback: 'Mapa već postoji!',
            warning: 'Pažnja! Ako se imena podudaraju, datoteke će biti prepisane!',
        },
        cropper: {
            title: 'Rezanje',
            apply: 'Primijeni',
            reset: 'Resetuj',
            save: 'Sačuvaj',
        },
    },
    notifications: {
        cutToClipboard: 'Izrezano u međuspremnik!',
        copyToClipboard: 'Kopirano u međuspremnik!',
    },
    response: {
        noConfig: 'Konfiguracija nije pronađena!',
        notFound: 'Nije pronađeno!',
        diskNotFound: 'Disk nije pronađen!',
        pathNotFound: 'Putanja nije pronađena!',
        diskSelected: 'Disk odabran!',
        // datoteke
        fileExist: 'Datoteka već postoji!',
        fileCreated: 'Datoteka kreirana!',
        fileUpdated: 'Datoteka ažurirana!',
        fileNotFound: 'Datoteka nije pronađena!',
        // direktorijumi
        dirExist: 'Mapa već postoji!',
        dirCreated: 'Mapa kreirana!',
        dirNotFound: 'Mapa nije pronađena',
        // akcije
        uploaded: 'Sve datoteke su učitane!',
        notAllUploaded: "Nisu sve datoteke učitane!",
        delNotFound: "Neki elementi nisu pronađeni!",
        deleted: 'Obrisano!',
        renamed: 'Preimenovano!',
        copied: 'Uspješno kopirano!',
        // zip
        zipError: 'Greška prilikom kreiranja arhive!',
        // acl


        aclError: 'Pristup odbijen!',
    },

    clearall:{
        clear_all_selection : 'Očisti sve selekcije',
        delete_all : 'Da li zaista želite obrisati sve odabrane datoteke?',
    }
};

export default bsn;
