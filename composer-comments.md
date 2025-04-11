This file contains comments for composer.json to store information about the package dependencies available in composer.json file. Developers are requested to mention any special usage of a package version or dependencies used in the project to make it easy for maintainers of the project to handle these special dependencies and update the project in future.

### Davibennun/Laravel-push-notification

Using forked branch "dev-laravel6" from Manish's Gihtub account which has been updated for laravel 6 support.

**Package name:**         davibennun/laravel-push-notification<br />
**Github link:**          <https://github.com/davibennun/laravel-push-notification><br />
**Packagist:**            <https://packagist.org/packages/davibennun/laravel-push-notification><br />
**Fork link:**            <https://github.com/mverma16/laravel-push-notification><br />
**Date**                  18-12-2019<br />
**Dependent packages:**   NONE<br />
**Developer:**            Manish Verma<br />
**Description:**          While updating laravel version to 6.0 forced composer to install the forked
					   branch from Github. As the package is not updated anymore now this was preventing
					   composer from updating Laravel so created a fork and added support for Laravel 6 in the froked branch.<br />
**Reason:**               The package is being used for sending push notifications to mobile apps
						using FCM. As the package is no longer supported we cloned the updated fork.<br />
**Expected impact:**      NONE<br />
**Todo:**                   There is a new package available <https://github.com/Edujugon/PushNotification>
						need to implement the functionality using this new package.

### Vsmoraes/Laravel-pdf

Using forked branch "dev-laravel6" from Manish's Gihtub account which has been updated for laravel 6 support.

**Package name:**         vsmoraes/laravel-pdf<br />
**Github link:**          <https://github.com/vsmoraes/pdf-laravel5><br />
**Packagist:**            <https://packagist.org/packages/vsmoraes/laravel-pdf><br />
**Fork link:**            <https://github.com/mverma16/pdf-laravel5.git><br />
**Date**                  18-12-2019<br />
**Dependent packages:**   NONE<br />
**Developer:**            Manish Verma<br />
**Description:**          While updating laravel version to 6.0 forced composer to install the forked
					   branch from GitHub. As the package is not updated anymore now this was preventing
					   composer from updating Laravel so created a fork and added support for Laravel 6 in the forked branch.<br />
**Reason:**               To able to update Laravel without breaking the system.<br />
**Expected impact:**      NONE<br />
**Todo:**                  Created the issue <https://github.com/vsmoraes/pdf-laravel5/issues/35> to get 						   an update for laravel. Seems the package is no longer updated so need to find 						   replacement of the package or if not being used then we need to remove the 
                       package.

### Php-imap/Php-imap

Using forked branch "dev-imap-faveo-build" from Manish's Gihtub account which has been modified to support the changes made in CustomMailbox.php class. As the class is using the properties which are now explicitly marked as private/protected in the main repo to satisfy psalm analytics but as those variables functionalities have been highly customized in the CustomMailbox.php the fork branch provides the same old functionality support with the latest updates in the package.
**Package name:**         php-imap/php-imap<br />
**Github link:**          <https://github.com/barbushin/php-imap><br />
**Packagist:**            <https://packagist.org/packages/php-imap/php-imap><br />
**Fork link:**            <https://github.com/mverma16/php-imap><br />
**Date**                  14-12-2021<br />
**Dependent packages:**   NONE<br />
**Developer:**            Manish Verma<br />
**Description:**          While updating the package found the breaking changes which would have not impacted the system if we had not made changes by extending the functionality of PhpImap/Mailbox class to CustomMailbox class. So created a fork and added support for usage of private properties by changing their access visibility in the forked branch.<br />
**Reason:**               To able to support custom changes made in the functionality of mail fetch classes<br />
**Expected impact:**      NONE<br />
**Todo:**                  Study and update CustomMaibox class to make it compatible with the actual package changes so that we can avoid maintaining these
changes in forked branch unnecessarily.
