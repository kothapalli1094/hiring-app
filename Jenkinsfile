pipeline {
    agent any

    tools {
        maven 'mvn3'
        jdk 'jdk17'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')    // Jenkins credentials ID
        GIT_CREDENTIALS = credentials('git-cred')
        IMAGE_NAME = "kothapalli1094/argocd"                   // your Docker Hub repo
        VERSION = "v${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout Code') {
           steps {
               echo '🔁 Checking out code from hiring-app repo...'
               checkout scm
            }
        }


        stage('Build WAR') {
            steps {
                echo '🏗️ Building WAR file using Maven...'
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                sh """
                docker build -t ${IMAGE_NAME}:${VERSION} .
                docker tag ${IMAGE_NAME}:${VERSION} ${IMAGE_NAME}:latest
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                echo '🚀 Pushing Docker image to Docker Hub...'
                sh """
                echo "${DOCKERHUB_CREDENTIALS_PSW}" | docker login -u "${DOCKERHUB_CREDENTIALS_USR}" --password-stdin
                docker push ${IMAGE_NAME}:${VERSION}
                docker push ${IMAGE_NAME}:latest
                docker logout
                """
            }
        }
    }

    post {
        success {
            echo "✅ Docker image built and pushed successfully: ${IMAGE_NAME}:${VERSION}"
        }
        failure {
            echo "❌ Docker image build or push failed!"
        }
    }
}
