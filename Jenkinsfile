pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/llucasls/thecliwizard', branch: 'main'
            }
        }
        stage('Deploy') {
            steps {
                sshagent(['wizard-pipeline-id']) {
                    sh 'rsync -vz --delete --exclude=".git" --exclude=".gitignore" --exclude="Jenkinsfile" --recursive --chown=www-data:www-data . lucas@31.220.109.252:/var/www/thecliwizard.xyz/'
                }
            }
        }
    }
}
