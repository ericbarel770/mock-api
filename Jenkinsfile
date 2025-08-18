pipeline {
    agent any

    environment {
        IMAGE = "docker.io/ebarel/mock-api:${env.BUILD_NUMBER}"
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
                sh(script: 'docker rm -f mock-api', returnStatus: true)
                sh 'docker run -d --rm -p 8000:8000 --name mock-api $IMAGE'
                sleep 5 // wait for container to start
            }
        }

        stage('Run Tests') {
            steps {
                sh(script: 'docker rm -f mock-api-test', returnStatus: true)
                sh 'docker run --name mock-api-test -w /app $IMAGE pytest -q --junitxml=/tmp/pytest-report.xml tests'
                sh 'docker cp mock-api-test:/tmp/pytest-report.xml ./pytest-report.xml'
                sh(script: 'docker rm -f mock-api-test', returnStatus: true)
            }
            post {
                always {
                    junit 'pytest-report.xml'
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

        stage('Run Final Container') {
            steps {
                sh(script: 'docker rm -f mock-api-final', returnStatus: true)
                sh 'docker run -d -p 8020:8000 --name mock-api-final $IMAGE'
            }
        }
    }
}
