pipeline {
    agent any
    stages {

        stage('Checkout Jenkinsfile') {
            steps {
                git url: 'https://github.com/chetashree10/app.git', branch: 'main'
            }
        }

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
                    sh 'mvn clean install'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                dir('app_code/complete') {
                    sh 'docker build -t chetu20/springboot-complete:latest .'
                    sh 'docker push chetu20/springboot-complete:latest'
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
        success { echo "✅ Pipeline completed successfully" }
        failure { echo "❌ Pipeline failed" }
    }
}
