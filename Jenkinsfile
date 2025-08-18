pipeline {
    agent any

    environment {
        IMAGE = "docker.io/ebarel/mock-api:${env.BUILD_NUMBER}"
        TESTS_PASSED = 'false'
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

        stage('Run Tests') {
            steps {
                script {                    
                    def testStatus = sh(script: "docker run --name mock-api-test -w /app $IMAGE pytest -q --junitxml=/tmp/pytest-report.xml tests", returnStatus: true)
                    sh(script: 'docker cp mock-api-test:/tmp/pytest-report.xml ./pytest-report.xml', returnStatus: true)
                    junit 'pytest-report.xml'
                    
                    env.TESTS_PASSED = testStatus == 0 ? 'true' : 'false'

                    echo "Test status: ${testStatus}"
                    echo "TESTS_PASSED environment variable: ${env.TESTS_PASSED}"

                    if (env.TESTS_PASSED == 'false') {
                        error 'Tests failed'
                    }
                }
            }
            post {
                always {
                    sh(script: 'docker rm -f mock-api-test', returnStatus: true)
                }
            }
        }

        stage('Push to Docker Hub only if tests pass') {
            when { expression { currentBuild.getExecution().getCurrentHead().getCurrentExecutable().getCurrentResult() == 'SUCCESS' } }
            steps {
                script {
                    echo "In Push stage - TESTS_PASSED value: ${env.TESTS_PASSED}"
                    echo "Condition evaluation: ${env.TESTS_PASSED == 'true'}"
                }
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
                    sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                    sh 'docker push $IMAGE'
                    sh(script: 'docker rm -f mock-api-final', returnStatus: true)
                    sh 'docker run -d -p 8000:8000 --name mock-api-final $IMAGE'
                }
            }
        }
    }
}
