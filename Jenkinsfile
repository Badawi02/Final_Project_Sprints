pipeline {
    agent any

    stages {
        stage('build') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws_cred',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh """
                            aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 636094856180.dkr.ecr.us-east-1.amazonaws.com
                            sudo docker build -t 636094856180.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER} -f Flask_Mysql_app/FlaskApp/Dockerfile
                            sudo docker push 636094856180.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER}
                            sudo docker build -t 636094856180.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER} -f Flask_Mysql_app/db/Dockerfile
                            sudo docker push 636094856180.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER}
                            sudo echo ${BUILD_NUMBER} > ../flask_app-build-number.txt
                        """
                    }
                }
            }
        }
    }
}
