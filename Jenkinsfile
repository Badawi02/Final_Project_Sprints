pipeline {
    agent any

    stages {
        stage('build') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'aws_cred', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 636094856180.dkr.ecr.us-east-1.amazonaws.com
                            docker build -t 636094856180.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER} -f Flask_Mysql_app/FlaskApp/Dockerfile
                            docker push 636094856180.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER}
                            docker build -t 636094856180.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER} -f Flask_Mysql_app/db/Dockerfile
                            docker push 636094856180.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER}
                            echo ${BUILD_NUMBER} > ../flask_app-build-number.txt
                        """
                    }
                }
            }
        }
    }
}
