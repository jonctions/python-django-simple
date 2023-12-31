pipeline {
    agent {
        label 'machine2'
    }
    options {
        ansiColor('xterm')
        gitLabConnection('GitLab')
    }
    environment {
        AUTHOR = 'Guillaume Rémy'
        PURPOSE    = 'This is a sample Django app'
        LIFE_QUOTE = 'The greatest glory in living lies not in never falling, but in rising every time we fall.'
        HARBOR_URL = 'harbor.qualibre-formations.fr'
        HARBOR_CREDS = credentials('harbor-id')
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code repository
                git branch: 'main',
                    url: 'https://gitlab.com/qualibre-info-formations/public/python-django-simple.git'
            }
        }
        stage('Unit tests') {
            agent {
                docker {
                    image 'python:3.6'
                    args '-u root:root'
                }
            }
            steps {
                updateGitlabCommitStatus name: 'unit tests', state: 'running'
                sh 'pip install -r requirements.txt'
                sh 'python manage.py test'
            }
            post {
                success {
                    updateGitlabCommitStatus name: 'unit tests', state: 'success'
                }
                failure {
                    updateGitlabCommitStatus name: 'unit tests', state: 'failed'
                }
            }
        }
        stage('Build') {
            environment {
                 COMMIT_SHA = """${sh(
                    returnStdout: true,
                    script: "git log -n 1 --pretty=format:'%H'"
                )}"""
            }
            steps {
                // Build your Django application
                sh 'docker build -t $HARBOR_URL/library/django-simple-app:$COMMIT_SHA .'
            }
        }
        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'SonarScanner'
            }
            steps {
                withSonarQubeEnv('SonarServer') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
        stage('Publish') {
            environment {
                 COMMIT_SHA = """${sh(
                    returnStdout: true,
                    script: "git log -n 1 --pretty=format:'%H'"
                )}"""
            }
            steps {
                sh 'docker login -u $HARBOR_CREDS_USR -p $HARBOR_CREDS_PSW $HARBOR_URL'
                sh 'docker push $HARBOR_URL/library/django-simple-app:$COMMIT_SHA'
            }
        }
    }
    post {
        success {
            build job: 'python django CD', parameters: [
                    textParam(name: 'COMMIT_SHA', value: """${sh(
                returnStdout: true,
                script: "git log -n 1 --pretty=format:'%H'"
            )}""")
                ]
        }
    }
}
