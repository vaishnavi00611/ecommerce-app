pipeline {
    agent any
    environment {
        EC2_HOST = '35.154.237.183'
        SSH_CRED_ID = 'ubuntu-ec2-key'
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
        stage('Dockerize') {
            steps {
                // Dockerfile is inside ./backend, so build context is ./backend
                sh 'docker build -t ecommerce-app ./backend'
            }
        }
        stage('Copy to EC2') {
            steps {
                sshagent (credentials: [SSH_CRED_ID]) {
                    sh """
                        scp -o StrictHostKeyChecking=no -r backend ubuntu@${EC2_HOST}:/home/ubuntu/
                    """
                }
            }
        }
        stage('Deploy on EC2') {
            steps {
                sshagent (credentials: [SSH_CRED_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} << 'EOF'
                        cd /home/ubuntu/backend
                        docker stop ecommerce-app || true
                        docker rm ecommerce-app || true
                        docker build -t ecommerce-app .
                        docker run -d -p 8080:8080 --name ecommerce-app ecommerce-app
                        EOF
                    """
                }
            }
        }
    }
}
