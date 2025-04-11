const { execSync } = require('child_process');

const testConfigs = [
    { root: 'tests/Unit/Frontend/Client', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/Agent', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/Admin', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/Common', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/Extra', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/FileManager', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/FormFields', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/helpers', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/HelpSection', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/MiniComponent', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/Navigation', match: '**/*.spec.js' },
    { root: 'tests/Unit/Frontend/ChartFactory', match: '**/*.spec.js' },
    { root: 'app/AutoAssign', match: '**/*.spec.js' },
    { root: 'app/Bill', match: '**/*.spec.js' },
    { root: 'app/FaveoLog', match: '**/*.spec.js' },
    { root: 'app/FaveoReport', match: '**/*.spec.js' },
    { root: 'app/Health', match: '**/*.spec.js' },
    { root: 'app/Location', match: '**/*.spec.js' },
    { root: 'app/Plugins/AllianceCRM', match: '**/*.spec.js' },
    { root: 'app/Plugins/AzureActiveDirectory', match: '**/*.spec.js' },
    { root: 'app/Plugins/Calendar', match: '**/*.spec.js' },
    { root: 'app/Plugins/Chat', match: '**/*.spec.js' },
    { root: 'app/Plugins/CustomCSS', match: '**/*.spec.js' },
    { root: 'app/Plugins/CustomJs', match: '**/*.spec.js' },
    { root: 'app/Plugins/Facebook', match: '**/*.spec.js' },
    { root: 'app/Plugins/Instagram', match: '**/*.spec.js' },
    { root: 'app/Plugins/Ldap', match: '**/*.spec.js' },
    { root: 'app/Plugins/LimeSurvey', match: '**/*.spec.js' },
    { root: 'app/Plugins/Line', match: '**/*.spec.js' },
    { root: 'app/Plugins/ServiceDesk', match: '**/*.spec.js' },
    { root: 'app/Plugins/Slack', match: '**/*.spec.js' },
    { root: 'app/Plugins/SMS', match: '**/*.spec.js' },
    { root: 'app/Plugins/Telephony', match: '**/*.spec.js' },
    { root: 'app/Plugins/Twitter', match: '**/*.spec.js' },
    { root: 'app/Plugins/FaveoRedaction', match: '**/*.spec.js' },
    { root: 'app/Plugins/SmartBonding', match: '**/*.spec.js' },
    { root: 'app/Plugins/EleaAssistant', match: '**/*.spec.js'},
    { root: 'app/Plugins/RemoteDesktop', match: '**/*.spec.js' },
    { root: 'app/Plugins/DataArchive', match: '**/*.spec.js' }
];

execSync('jest --clearCache', { stdio: 'inherit' });

for (const config of testConfigs) {
    try {
        execSync(`jest --maxWorkers=3 --roots=${config.root} --testMatch=${config.match}`, { stdio: 'inherit' });
    } catch (error) {
        console.error(`Tests failed for ${config.root}. Stopping further tests.`);
        process.exit(1); // Exit with an error code to ensure Jenkins detects the failure
    }
}