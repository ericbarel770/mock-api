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
                sh 'docker rm -f mock-api || true'
                sh 'docker run -d --rm -p 8000:8000 --name mock-api $IMAGE'
                sleep 5 // wait for container to start
            }
        }

        stage('Run Tests') {
            steps {
                sh 'docker rm -f mock-api-test || true'
                sh 'docker run --rm --name mock-api-test -v $WORKSPACE:/workspace -w /workspace $IMAGE pytest -q --junitxml=pytest-report.xml tests'
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
                sh 'docker rm -f mock-api-final || true'
                sh 'docker run -d -p 8020:8020 --name mock-api-final $IMAGE'
            }
        }
    }
}
