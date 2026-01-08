pipeline {
    agent any

    environment {
        APP_REPO   = "https://github.com/chetashree10/gs-spring-boot.git"
        IMAGE_NAME = "chetu20/springboot-complete"
        IMAGE_TAG  = "latest"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Pipeline Repo') {
            steps {
                checkout scm
            }
        }

        stage('Checkout Application Code') {
            steps {
                dir('app_code') {
                    git branch: 'main', url: "${APP_REPO}"
                }
            }
        }

        stage('Build Application') {
            steps {
                dir('app_code/complete') {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('app_code/complete') {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                      echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                      docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes (Minikube)') {
            steps {
                sh '''
                  kubectl config use-context minikube
                  kubectl apply -f k8s/dev/namespace.yaml
                  kubectl apply -f k8s/dev/
                '''
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Pipeline completed successfully"
        }
        failure {
            echo "❌ CI/CD Pipeline failed"
        }
    }
}
