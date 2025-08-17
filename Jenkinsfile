pipeline {
    agent any

    environment {
        IMAGE = "bmc/mock-api:${env.BUILD_NUMBER}"
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
                sh 'docker run --rm --name mock-api-test $IMAGE pytest --junitxml=pytest-report.xml -q'
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
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
                        // Login to Docker Hub
                        sh 'echo $DH_PASS | docker login -u $DH_USER --password-stdin'
                        
                        // Check if we can push (this will fail early if there are permission issues)
                        sh '''
                            echo "Attempting to push image: $IMAGE"
                            if docker push $IMAGE; then
                                echo "Successfully pushed $IMAGE"
                            else
                                echo "Failed to push $IMAGE"
                                echo "This could be due to:"
                                echo "1. Repository doesn't exist on Docker Hub"
                                echo "2. Insufficient permissions to push to this repository"
                                echo "3. Wrong repository name or namespace"
                                exit 1
                            fi
                        '''
                    }
                }
            }
            post {
                failure {
                    echo "Docker push failed. Please check:"
                    echo "1. Repository exists on Docker Hub: https://hub.docker.com/r/your-username/mock-api"
                    echo "2. Your Docker Hub credentials have push permissions"
                    echo "3. You're using the correct repository name"
                }
            }
        }

        stage('Run Final Container') {
            steps {
                sh 'docker run -d --rm -p 8000:8000 --name mock-api-final $IMAGE'
            }
        }
    }
}
