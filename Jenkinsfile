pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "chetu20/springboot-complete"
        DOCKER_TAG   = "latest"
        KUBECONFIG   = "/root/.kube/config"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/chetashree10/app.git'
            }
        }

        stage('Build & Unit Test') {
            steps {
                dir('app') {
                    sh 'mvn clean test package'
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('app') {
                    sh '''
                      docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                    '''
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASS')]) {
                    sh '''
                      echo $DOCKER_PASS | docker login -u chetu20 --password-stdin
                      docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                    '''
                }
            }
        }

        stage('Deploy to Dev (Kubernetes)') {
            steps {
                sh '''
                  kubectl apply -f k8s/dev/namespace.yaml
                  kubectl apply -f k8s/dev/
                '''
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
