pipeline {
    agent {
        label 'machine2'
    }
    options {
        ansiColor('xterm')
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
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
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
        stage('Deploy') {
            environment {
                 COMMIT_SHA = """${sh(
                    returnStdout: true,
                    script: "git log -n 1 --pretty=format:'%H'"
                )}"""
            }
            steps {
                // Deploy your Django application
                sh 'docker rm -f django-sample-app || true'
                sh 'docker run --name django-sample-app -d -p 8000:8000 -it -e AUTHOR -e PURPOSE -e LIFE_QUOTE $HARBOR_URL/library/django-simple-app:$COMMIT_SHA'
            }
        }
    }
}