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
                    sh 'rsync -avz --delete --exclude=".git" --recursive --chown=www-data:www-data . lucas@cassandra:/var/www/thecliwizard.xyz/'
                }
            }
        }
    }
}
