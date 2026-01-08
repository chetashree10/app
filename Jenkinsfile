pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "chetu20/springboot-complete:latest" // Docker Hub repo
        DOCKER_CREDENTIALS_ID = "dockerhub-creds"          // Add your DockerHub credentials in Jenkins
        KUBE_NAMESPACE = "dev"
    }

    stages {

        stage('Checkout App Code') {
            steps {
                git url: 'https://github.com/chetashree10/gs-spring-boot.git', branch: 'main'
            }
        }

        stage('Build & Unit Test') {
            steps {
                dir('complete') {
                    // Build Maven project
                    sh 'mvn clean test package'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                dir('complete') {
                    script {
                        // Login to Docker Hub
                        withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        }

                        // Build and push Docker image
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }

        stage('Deploy to Dev (Kubernetes)') {
            steps {
                dir('complete/k8s/dev') {
                    // Apply K8s manifests
                    sh 'kubectl apply -f .'
                }
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully. Docker image pushed to ${DOCKER_IMAGE}"
        }
        failure {
            echo "❌ Pipeline failed. Please check the logs"
        }
    }
}
