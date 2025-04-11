import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';
import * as fs from 'fs';
import * as ini from 'ini';
import path from 'path';

// Read APP_VERSION from faveoconfig.ini
const iniConfig = ini.parse(fs.readFileSync('./storage/faveoconfig.ini', 'utf-8'));
const version = iniConfig.APP_VERSION;

// Function to get `APP_VERSION`
const getCoreVersion = () => version;

// Core entry files
const coreEntryFiles = [
    { path: 'resources/assets/js/app.js', version: getCoreVersion() },
    { path: 'resources/assets/js/admin.js', version: getCoreVersion() },
    { path: 'resources/assets/js/agent.js', version: getCoreVersion() },
    { path: 'resources/assets/js/navigation.js', version: getCoreVersion() },
    { path: 'resources/assets/js/headerMenu.js', version: getCoreVersion() },
    { path: 'resources/assets/js/chatWidget.js', version: getCoreVersion() },
    { path: 'resources/assets/js/helpwidget.js', version: getCoreVersion() },
    { path: 'app/Health/views/js/healthCheck.js', version: getCoreVersion() },
    { path: 'app/FaveoModule/views/js/optimizeModules.js', version: getCoreVersion() },
    { path: 'app/TimeTrack/resources/views/js/timeTrack.js', version: getCoreVersion() },
    { path: 'app/Notify/views/js/notify.js', version: getCoreVersion() },
    { path: 'app/Location/views/js/systemLocation.js', version: getCoreVersion() },
    { path: 'app/AutoAssign/views/js/autoAssign.js', version: getCoreVersion() },
    { path: 'app/FaveoReport/views/js/systemReport.js', version: getCoreVersion() },
    { path: 'app/FaveoLog/views/js/systemLog.js', version: getCoreVersion() },
    { path: 'app/Bill/views/js/systemBilling.js', version: getCoreVersion() }
];

const pluginJsMapping = {
    'AdHocApproval': 'adHocApproval.js',
    'AllianceCRM': 'allianceCRM.js',
    'AttachmentScanner': 'AttachmentScanner.js',
    'AzureActiveDirectory': 'azureActiveDirectory.js',
    'Calendar': 'calendar.js',
    'Chat': 'chat.js',
    'CRTWorkflow': 'crtWorkflow.js',
    'CustomCSS': 'customCss.js',
    'CustomJs': 'customJs.js',
    'CustomLanguage': 'customLang.js',
    'DepartmentStatusLink': 'departmentStatus.js',
    'EleaAssistant': 'eleaAssistant.js',
    'Facebook': 'facebook.js',
    'FaveoRedaction': 'faveoRedaction.js',
    'Instagram': 'instagram.js',
    'Ldap': 'ldap.js',
    'LimeSurvey': 'limesurvey.js',
    'Line': 'line.js',
    'RemoteDesktop': 'remoteDesktop.js',
    'ServiceDesk': 'serviceDesk.js',
    'Slack': 'slack.js',
    'SMS': 'sms.js',
    'SmartBonding': 'SmartBonding.js',
    'Telephony': 'telephony.js',
    'TicketArchive': 'TicketArchive.js',
    'Twitter': 'twitter.js',
    'Whatsapp': 'whatsapp.js',
    'Zendesk': 'zendesk.js',
    'DataArchive': 'dataArchive.js'
};

// Function to extract version and path from `config.php`
const getPluginEntries = () => {
    const pluginsDir = path.resolve('app/Plugins');
    let pluginEntries = [];

    if (fs.existsSync(pluginsDir)) {
        fs.readdirSync(pluginsDir).forEach(pluginName => {
            const configPath = path.join(pluginsDir, pluginName, 'config.php');

            if (fs.existsSync(configPath)) {
                const configContent = fs.readFileSync(configPath, 'utf-8');

                const pathMatch = configContent.match(/'path'\s*=>\s*['"]([^'"]+)['"]/);
                const versionMatch = configContent.match(/'version'\s*=>\s*['"]([^'"]+)['"]/);

                if (pathMatch && versionMatch) {
                    const pluginPath = pathMatch[1];
                    const pluginVersion = `v${versionMatch[1]}`;
                    const jsDir = path.join(pluginsDir, pluginPath, 'views/js');

                    let jsFiles = [];

                    if (fs.existsSync(jsDir)) {
                        if (pluginJsMapping[pluginName]) {
                            jsFiles.push(pluginJsMapping[pluginName]);
                        } else {
                            jsFiles = fs.readdirSync(jsDir).filter(file => file.endsWith('.js'));
                        }
                        jsFiles.forEach(jsFile => {
                            const fullJsPath = `app/Plugins/${pluginPath}/views/js/${jsFile}`;
                            if (fs.existsSync(fullJsPath)) {
                                pluginEntries.push({ path: fullJsPath, version: pluginVersion, isPlugin: true, pluginPath, pluginName });
                            } else {
                                console.warn(`File not found: ${fullJsPath}`);
                            }
                        });
                    }
                }
            }
        });
    }

    return pluginEntries;
};

// Get all plugin entry files dynamically
const pluginEntryFiles = getPluginEntries();

// Combine all entries
const allEntries = [...coreEntryFiles, ...pluginEntryFiles];

const targetPlugin = process.env.PLUGIN || null;

console.log(`Building ${targetPlugin ? `plugin: ${targetPlugin}` : 'core'}`);

const filteredEntries = targetPlugin
    ? allEntries.filter(entry => entry.isPlugin && entry.pluginName === targetPlugin)
    : allEntries;

export default defineConfig({
    server: {
        hmr: { host: 'localhost' },
        cors: {
            origin: '*',
            methods: ['GET', 'POST', 'PUT', 'DELETE'],
            allowedHeaders: ['Content-Type'],
            credentials: true
        }
    },

    resolve: {
        alias: {
            vue: 'vue/dist/vue.esm-bundler.js',
            '@': '/resources/assets/js',
        }
    },

    build: {
        emptyOutDir: false, // Ensure the output directory is emptied before building
        manifest: true, // Generate manifest.json for asset resolution
        rollupOptions: {
            output: {
                manualChunks: undefined,
                entryFileNames: ({ name }) => {
                    const entry = filteredEntries.find(e => path.basename(e.path, '.js') === name);
                    if (entry && entry.isPlugin) {
                        return `plugins/${entry.pluginPath}/${entry.version}/entry/[name].js`; // Remove version from path
                    }
                    return `${version}/entry/[name].js`; // Remove version from path
                },
                chunkFileNames: ({ name }) => {
                    const entry = filteredEntries.find(e => e.path.includes(name));
                    if (entry && entry.isPlugin) {
                        return `plugins/${entry.pluginPath}/${entry.version}/chunks/[name].js`; // Remove version from path
                    }
                    return `${version}/chunks/[name].js`; // Remove version from path
                },
                assetFileNames: ({ name }) => {
                    const entry = filteredEntries.find(e => {
                        return e.path.includes(name.split('.').shift())
                    });
                    if (entry && entry.isPlugin) {
                        return `plugins/${entry.pluginPath}/${entry.version}/assets/[name][extname]`; // Remove version from path
                    }
                    return `${version}/assets/[name][extname]`; // Remove version from path
                },
            },
        },
    },

    plugins: [
        vue({
            template: {
                compilerOptions: {
                    isCustomElement: (tag) => tag.startsWith('is-')
                }
            }
        }),
        laravel({
            input: filteredEntries.map(e => e.path),
            refresh: true,
        })
    ]
});