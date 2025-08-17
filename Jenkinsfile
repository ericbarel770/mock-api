pipeline {
    agent any

    environment {
        IMAGE = "docker.io/bmc/mock-api:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d --rm -p 8000:8000 --name mock-api $IMAGE'
                sleep 5 // wait for container to start
            }
        }

        stage('Run Tests') {
            steps {
                sh 'pytest --junitxml=pytest-report.xml -q'
            }
            post {
                always {
                    junit 'pytest-report.xml'
                    sh 'docker stop mock-api || true'
                }
            }
        }

        stage('Push to Docker Hub') {
            when { expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') } }
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
                    sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                    sh 'docker push $IMAGE'
                }
            }
        }

        stage('Pull & Run') {
            steps {
                sh 'docker pull $IMAGE'
                sh 'docker run -d -p 8000:8000 --rm --name mock-api-final $IMAGE'
            }
        }
    }
}
