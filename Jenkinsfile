pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS_ID = 'faveobot'
        MYSQL_CREDENTIALS_ID = 'mysql_credentials_id'
        WORKSPACE_DIR = '/home/jenkins/workspace'
        REPO_ID = 'faveo-helpdesk-advance.git'
    }

    stages {
        stage('Checking out and getting your code...') {
            steps {
                withCredentials([usernamePassword(credentialsId: GITHUB_CREDENTIALS_ID, usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
                    checkout scm
                     script {
                       sh 'git remote set-url origin https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/ladybirdweb/${REPO_ID}'
            }
                }
            }
        }

 stage('Checking what are your code changes...') {
    steps {
        withCredentials([usernamePassword(credentialsId: GITHUB_CREDENTIALS_ID, usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
            script {
                def repoName = scm.userRemoteConfigs[0].url.tokenize('/').last().replace('.git', '')
                // Resetting the remote URL with credentials
                sh 'git remote set-url origin https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/ladybirdweb/${REPO_ID}'
                sh 'git fetch origin development:refs/remotes/origin/development'
                def changedFiles = sh(script: "git diff --name-only origin/development...HEAD", returnStdout: true).trim()
                echo "Changed Files:\n${changedFiles}"

                // Check for frontend file changes
                def frontendChanged = changedFiles.contains('.vue') || changedFiles.contains('.js') || changedFiles.contains('.css')

                def backendChanged = changedFiles.contains('.php')

                env.FRONTEND_CHANGED = frontendChanged.toString()
                env.BACKEND_CHANGED = backendChanged.toString()

            }
        }
    }
}


        stage('Running vue tests...') {
            when {
                expression { env.FRONTEND_CHANGED == 'true' }
            }
            steps {
                sh 'rm -rf node_modules'
                sh 'npm install'
                sh 'npm test'
            }
        }

        stage('Setting up backend environment... and testing') {
            when {
                expression { env.BACKEND_CHANGED == 'true' }
            }
            steps {
                sh 'composer dump-autoload'
                script {
                    def buildNumber = env.BUILD_NUMBER
                    def prNumber = env.CHANGE_ID ?: ''
                    def repoName = scm.userRemoteConfigs[0].url.tokenize('/').last().replace('.git', '')

                    withCredentials([usernamePassword(credentialsId: GITHUB_CREDENTIALS_ID, usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
                        if (!prNumber) {
                            prNumber = sh(script: """
                                curl -s -u ${GITHUB_USER}:${GITHUB_TOKEN} \
                                "https://api.github.com/repos/ladybirdweb/${repoName}/pulls?head=${GITHUB_USER}:${env.BRANCH_NAME}" \
                                | jq '.[0].number' | tr -d '"'
                            """, returnStdout: true).trim()
                        }

                        def uniqueDatabaseName = "helpdesk_${buildNumber}_${prNumber}"

                        withCredentials([
                            usernamePassword(credentialsId: MYSQL_CREDENTIALS_ID, usernameVariable: 'DB_USER', passwordVariable: 'DB_PASS')
                        ]) {
                            sh """
                            echo "Creating database ${uniqueDatabaseName}" && \
                            mysql -u ${DB_USER} -p${DB_PASS} -e "DROP DATABASE IF EXISTS ${uniqueDatabaseName}; CREATE DATABASE ${uniqueDatabaseName};" && \
                            php artisan optimize:clear && \
                            php artisan testing-setup --username=${DB_USER} --password=${DB_PASS} --database=${uniqueDatabaseName} && \
                            COMPOSER_MEMORY_LIMIT=-1 php artisan test --testsuite=admin,agent,auth,common,helper,middleware,model,sla,request,seeders,traits,utility,faveo-storage,client,plugins,modules && \
                            COMPOSER_MEMORY_LIMIT=-1 php artisan test --testsuite=ldap,azure-ad && \
                            COMPOSER_MEMORY_LIMIT=-1 php artisan test --testsuite=service-desk && \
                            COMPOSER_MEMORY_LIMIT=-1 php artisan test --testsuite=department-status-link && \
                            COMPOSER_MEMORY_LIMIT=-1 php artisan test --testsuite=faveo-report && \
                            COMPOSER_MEMORY_LIMIT=-1 php artisan test --testsuite=data-archive
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                def commitSha = env.GIT_COMMIT
                def repoName = scm.userRemoteConfigs[0].url.tokenize('/').last().replace('.git', '')
                def prNumber = env.CHANGE_ID ?: ''

                withCredentials([usernamePassword(credentialsId: GITHUB_CREDENTIALS_ID, usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
                    if (!prNumber) {
                        prNumber = sh(script: """
                            curl -s -u ${GITHUB_USER}:${GITHUB_TOKEN} \
                            "https://api.github.com/repos/ladybirdweb/${repoName}/pulls?head=${GITHUB_USER}:${env.BRANCH_NAME}" \
                            | jq '.[0].number' | tr -d '"'
                        """, returnStdout: true).trim()
                    }

                    def status = currentBuild.currentResult == 'SUCCESS' ? 'success' : 'failure'
                    def statusUrl = "${env.BUILD_URL}"
                    def description = currentBuild.currentResult == 'SUCCESS' ? 'Build successful' : 'Build failed'

                    sh """
                    curl -u ${GITHUB_USER}:${GITHUB_TOKEN} \
                         -d '{"state": "${status}", "target_url": "${statusUrl}", "description": "${description}", "context": "Jenkins"}' \
                         https://api.github.com/repos/ladybirdweb/${repoName}/statuses/${commitSha}
                    """

                    if (currentBuild.currentResult != 'SUCCESS' && prNumber) {
                        echo "Closing the PR due to build failure..."
                        sh """
                        curl -X PATCH -u ${GITHUB_USER}:${GITHUB_TOKEN} \
                             -d '{"state": "closed"}' \
                             https://api.github.com/repos/ladybirdweb/${repoName}/pulls/${prNumber}
                        """
                    }
                }
            }

            script {
                def buildNumber = env.BUILD_NUMBER
                def prNumber = env.CHANGE_ID ?: ''
                def repoName = scm.userRemoteConfigs[0].url.tokenize('/').last().replace('.git', '')

                withCredentials([usernamePassword(credentialsId: GITHUB_CREDENTIALS_ID, usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
                    if (!prNumber) {
                        prNumber = sh(script: """
                            curl -s -u ${GITHUB_USER}:${GITHUB_TOKEN} \
                            "https://api.github.com/repos/ladybirdweb/${repoName}/pulls?head=${GITHUB_USER}:${env.BRANCH_NAME}" \
                            | jq '.[0].number' | tr -d '"'
                        """, returnStdout: true).trim()
                    }

                    def uniqueDatabaseName = "helpdesk_${buildNumber}_${prNumber}"

                    withCredentials([
                        usernamePassword(credentialsId: MYSQL_CREDENTIALS_ID, usernameVariable: 'DB_USER', passwordVariable: 'DB_PASS')
                    ]) {
                        sh """
                        echo "Dropping database ${uniqueDatabaseName}" && \
                        mysql -u ${DB_USER} -p${DB_PASS} -e "DROP DATABASE IF EXISTS ${uniqueDatabaseName};" && \
                        rm -rf /home/jenkins/automation/${uniqueDatabaseName}.sql
                        """
                        cleanWs()
                    }
                }
            }
        }
    }
}