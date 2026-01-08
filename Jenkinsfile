pipeline {
    agent any

    environment {
        APP_NAME = "springboot-complete"
        DOCKER_IMAGE = "chetu20/springboot-complete"
        DOCKER_CREDENTIALS_ID = "dockerhub-creds"
        K8S_NAMESPACE = "dev"
    }

    stages {

        stage('Checkout App Code') {
            steps {
                // Checkout your Spring Boot repo
                dir('/mnt') {
                    git branch: 'main', url: 'https://github.com/chetashree10/gs-spring-boot.git'
                }
            }
        }

        stage('Build & Package') {
            steps {
                dir('/mnt/gs-spring-boot/complete') {
                    sh './mvnw clean install'
                }
            }
        }

        stage('Docker Build') {
            steps {
                dir('/mnt/gs-spring-boot/complete') {
                    // Make sure Dockerfile is present here
                    sh 'docker build -t $DOCKER_IMAGE:latest .'
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "$DOCKER_CREDENTIALS_ID",
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
                sh '''
                    kubectl apply -f /mnt/gs-spring-boot/complete/k8s/dev/
                    kubectl rollout status deployment/springboot-complete -n dev
                '''
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
