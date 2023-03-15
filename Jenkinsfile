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
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 636094856180.dkr.ecr.us-east-1.amazonaws.com
                            docker build -t flask_app:${BUILD_NUMBER} Flask_Mysql_app/FlaskApp
                            docker tag flask_app:${BUILD_NUMBER} 636094856180.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER}
                            docker push 636094856180.dkr.ecr.us-east-1.amazonaws.com/flask_app:${BUILD_NUMBER}
                            docker build -t mysql:${BUILD_NUMBER} Flask_Mysql_app/db
                            docker tag mysql:${BUILD_NUMBER} 636094856180.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER}
                            docker push 636094856180.dkr.ecr.us-east-1.amazonaws.com/mysql:${BUILD_NUMBER}
                            echo ${BUILD_NUMBER} > ../flask_app-build-number.txt
                        """
                    }
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'k8s_cred', variable: 'KUBECONFIG')]) {
                        sh """
                            export BUILD_NUMBER=\$(cat ../flask_app-build-number.txt)
                            mv DeploymentFiles_app/deploy_app.yml Deployment/deploy_app.yml.tmp
                            mv DeploymentFiles_app/deploy_db.yml Deployment/deploy_db.yaml.tmp
                            cat DeploymentFiles_app/deploy_app.yml.tmp | envsubst > Deployment/deploy_app.yml
                            cat DeploymentFiles_app/deploy_db.yaml.tmp | envsubst > Deployment/deploy_db.yaml
                            rm -f DeploymentFiles_app/deploy_app.yml.tmp
                            rm -f DeploymentFiles_app/deploy_db.yaml.tmp
                            kubectl apply -f DeploymentFiles_app --kubeconfig=${KUBECONFIG}
                        """
                    }
                }
            }
        }
    }
}
