<?php declare(strict_types = 1);

namespace PHPStan\ExtensionInstaller;

/**
 * This class is generated by phpstan/extension-installer.
 * @internal
 */
final class GeneratedConfig
{

	public const EXTENSIONS = array (
  'nesbot/carbon' => 
  array (
    'install_path' => '/var/www/html/karthi/vendor/nesbot/carbon',
    'relative_install_path' => '../../../nesbot/carbon',
    'extra' => 
    array (
      'includes' => 
      array (
        0 => 'extension.neon',
      ),
    ),
    'version' => '2.72.6',
    'phpstanVersionConstraint' => NULL,
  ),
  'phpstan/phpstan-phpunit' => 
  array (
    'install_path' => '/var/www/html/karthi/vendor/phpstan/phpstan-phpunit',
    'relative_install_path' => '../../phpstan-phpunit',
    'extra' => 
    array (
      'includes' => 
      array (
        0 => 'extension.neon',
        1 => 'rules.neon',
      ),
    ),
    'version' => '1.4.2',
    'phpstanVersionConstraint' => '>=1.12.0.0-dev, <2.0.0.0-dev',
  ),
);

	public const NOT_INSTALLED = array (
);

	/** @var string|null */
	public const PHPSTAN_VERSION_CONSTRAINT = '>=1.12.0.0-dev, <2.0.0.0-dev';

	private function __construct()
	{
	}

}
