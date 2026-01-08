pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "chetu20/springboot-complete:latest"
        KUBE_NAMESPACE = "dev"
    }

    stages {

        stage('Checkout App Code') {
            steps {
                dir('app_code') {
                    git url: 'https://github.com/chetashree10/gs-spring-boot.git', branch: 'main'
                }
            }
        }

        stage('Build & Unit Test') {
            steps {
                dir('app_code/complete') {
                    sh 'mvn clean test package'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                dir('app_code/complete') {
                    sh """
                        docker build -t ${DOCKER_IMAGE} .
                        docker push ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Deploy to Dev (Kubernetes)') {
            steps {
                dir('app_code/k8s/dev') {
                    sh 'kubectl apply -f .'
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
