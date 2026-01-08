pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "chetu20/springboot-complete"
        DOCKER_CREDENTIALS_ID = "dockerhub-creds"
        K8S_NAMESPACE = "dev"
    }

    stages {

        stage('Checkout Jenkins Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/chetashree10/app.git'
            }
        }

        stage('Checkout Application Code') {
            steps {
                dir('app_code') {
                    git branch: 'main',
                        url: 'https://github.com/chetashree10/gs-spring-boot.git'
                }
            }
        }

        stage('Build Spring Boot App') {
            steps {
                dir('app_code/complete') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                dir('app_code/complete') {
                    withCredentials([usernamePassword(
                        credentialsId: DOCKER_CREDENTIALS_ID,
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh '''
                        docker build -t ${DOCKER_IMAGE}:latest .
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${DOCKER_IMAGE}:latest
                        '''
                    }
                }
            }
        }

        stage('Deploy to Dev (Kubernetes)') {
            steps {
              sh '''
        kubectl get nodes

        kubectl apply -f app/k8s/dev/namespace.yaml || true
        kubectl apply -n dev -f app/k8s/dev/configmap.yaml
        kubectl apply -n dev -f app/k8s/dev/deployment.yaml
        kubectl apply -n dev -f app/k8s/dev/service.yaml

        kubectl rollout status deployment/springboot-complete -n dev
        '''
            }
        }
    }

    post {
        success {
            echo '✅ CI/CD Pipeline executed successfully'
        }
        failure {
            echo '❌ CI/CD Pipeline failed'
        }
    }
}
