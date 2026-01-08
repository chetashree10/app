pipeline {
    agent any

    environment {
        APP_NAME = "springboot-demo"
        DOCKER_IMAGE = "dockerhub_username/springboot-demo"  // <-- Replace with your DockerHub username
        DOCKER_CREDENTIALS_ID = "dockerhub-creds"
        K8S_NAMESPACE = "dev"
    }

    stages {

        stage('Checkout Jenkinsfile') {
            steps {
                // This is the repo that contains the Jenkinsfile itself
                git branch: 'main', url: 'https://github.com/chetashree10/app.git'
            }
        }

        stage('Checkout App Code') {
            steps {
                // Checkout the Spring Boot app into a subfolder 'app_code'
                dir('app_code') {
                    git branch: 'main', url: 'https://github.com/chetashree10/gs-spring-boot.git'
                }
            }
        }

        stage('Build & Unit Test') {
            steps {
                dir('app_code') {
                    // Clean, test, and package the Spring Boot app
                    sh 'mvn clean test package'
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('app_code') {
                    // Build Docker image
                    sh 'docker build -t $DOCKER_IMAGE:latest .'
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKER_CREDENTIALS_ID,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $DOCKER_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy to Dev (Kubernetes)') {
            steps {
                dir('app_code') {
                    // Apply Kubernetes manifests in dev namespace
                    sh '''
                    kubectl apply -n $K8S_NAMESPACE -f k8s/dev/
                    kubectl rollout status deployment/springboot-app -n $K8S_NAMESPACE
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline executed successfully'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
