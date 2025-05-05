pipeline {
    agent any
    environment {
        EC2_HOST = '43.205.114.59'
        SSH_CRED_ID = 'ubuntu-ec2-key'
        DOCKER_HUB_IMAGE = 'vaishu00611/ecommerce-app'
    }
    stages {
        stage('Clone') {
            steps {
                git 'https://github.com/vaishnavi00611/ecommerce-app'
            }
        }

        stage('Build') {
            steps {
                dir('backend') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Dockerize & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker build -t \$DOCKER_HUB_IMAGE ./backend
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        docker push \$DOCKER_HUB_IMAGE
                        docker logout
                    """
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sshagent (credentials: [SSH_CRED_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} '
                            docker stop ecommerce-app || true &&
                            docker rm ecommerce-app || true &&
                            docker pull ${DOCKER_HUB_IMAGE} &&
                            docker run -d -p 8081:8080 --name ecommerce-app ${DOCKER_HUB_IMAGE}
                        '
                    """
                }
            }
        }
    }
}
