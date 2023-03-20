pipeline {
    agent any
    environment {
        USER_ID = credentials('user_id')
    }

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
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com
                            docker build -t flask_app:${BUILD_NUMBER} Flask_Mysql_app/FlaskApp
                            docker tag flask_app:${BUILD_NUMBER} ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER}
                            docker push ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER}
                            docker build -t mysql:${BUILD_NUMBER} Flask_Mysql_app/db
                            docker tag mysql:${BUILD_NUMBER} ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER}
                            docker push ${USER_ID}.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER}
                            echo ${BUILD_NUMBER} > ../flask_app-build-number.txt
                            echo ${USER_ID} > ../flask_app-user-id.txt
                        """
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws_cred',
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                        sh """
                            aws eks --region us-east-1 update-kubeconfig --name cluster
                            export BUILD_NUMBER=\$(cat ../flask_app-build-number.txt)
                            export USER_ID=\$(cat ../flask_app-user-id.txt)
                            mv DeploymentFiles_app/deploy_app.yml DeploymentFiles_app/deploy_app.yml.tmp
                            mv DeploymentFiles_app/deploy_db.yml DeploymentFiles_app/deploy_db.yml.tmp
                            cat DeploymentFiles_app/deploy_app.yml.tmp | envsubst > DeploymentFiles_app/deploy_app.yml
                            cat DeploymentFiles_app/deploy_db.yml.tmp | envsubst > DeploymentFiles_app/deploy_db.yml
                            rm -f DeploymentFiles_app/deploy_app.yml.tmp
                            rm -f DeploymentFiles_app/deploy_db.yml.tmp
                            kubectl apply -f Deploy_nginx_ingress_controller
                            kubectl apply -f DeploymentFiles_app
                            sleep 20
                            kubectl apply -f Deploy_ingress
                        """
                    }
                }
            }
        }
    }
}
