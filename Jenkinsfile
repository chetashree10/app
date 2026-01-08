pipeline {
    agent any

    environment {
        APP_NAME = "springboot-complete"
        DOCKER_IMAGE = "chetu20/springboot-complete"
        DOCKER_CREDENTIALS_ID = "dockerhub-creds"
        K8S_NAMESPACE = "dev"
    }

    stages {

        stage('Checkout Jenkinsfile') {
            steps {
                // Jenkinsfile repo
                git branch: 'main', url: 'https://github.com/chetashree10/app.git'
            }
        }

        stage('Checkout Spring Boot App') {
            steps {
                // Spring Boot repo cloned into 'app_code'
                dir('app_code') {
                    git branch: 'main', url: 'https://github.com/chetashree10/gs-spring-boot.git'
                }
            }
        }

        stage('Build & Unit Test') {
            steps {
                // Run Maven exactly where pom.xml exists
                dir('app_code/complete') {
                    sh './mvnw clean install'
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('app_code/complete') {
                    // Build Docker image from folder containing .jar
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
                dir('app_code/complete') {
                    // Adjust path if k8s manifests are inside 'k8s/dev/'
                    sh '''
                    kubectl apply -n $K8S_NAMESPACE -f k8s/dev/
                    kubectl rollout status deployment/$APP_NAME -n $K8S_NAMESPACE
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
