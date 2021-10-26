pipeline {
    agent none
    //see https://www.jenkins.io/doc/book/pipeline/syntax/#options    
    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
        disableResume()
        timeout(time: 1, unit: 'HOURS')
        skipDefaultCheckout()
        skipStagesAfterUnstable()
    }
    stages {
        
        stage('Get files') {
            agent { label 'terraform:1.0' }
            steps {
                container('terraform') {
                    checkout scm

                    stash includes: '**', name: 'terraform-files'
                }
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========A executed successfully========"
                }
                failure{
                    echo "========A execution failed========"
                }
                cleanup {
                    cleanWs()
                }
            }
        }

        stage('Plan dev') {
            agent {
                label 'terraform:1.0'
            }

            environment {
                TF_VAR_ENV = "dev"
            }

            steps {
            unstash 'terraform-files'
                container('terraform') {
                    dir("vault/config/infrastructure"){
                      withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "qf-aws",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                         sh "terragrunt run-all plan --terragrunt-non-interactive"
                        }
                    }
                }
            }
            post {
                failure{
                        echo "========Pipeline execution failed========"
                    }
                }
        }

        stage('Apply on DEV') {
            agent {
                label 'terraform:1.0'
            }
            environment {
                TF_VAR_ENV = "dev"
            }
            steps {
            unstash 'terraform-files'
                container('terraform') {
                   dir("vault/config/infrastructure"){
                       script{
                        withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "qf-aws",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                            sh "terragrunt run-all apply --terragrunt-non-interactive"
                            def ip = sh(script: 'terragrunt run-all output leader', returnStdout: true)
                            echo "${ip}"
                            env.TF_VAR_VAULT_URL = "${ip}"
                            echo "${env.TF_VAR_VAULT_URL}"
                            }
                        }
                    }
                }
            }
            post {
                cleanup {
                    cleanWs()
                }
            }
        }

        stage('Plan Vault config on DEV') {
            agent {
                label 'terraform:1.0'
            }

            environment {
                TF_VAR_ENV = "dev"
            }

            steps {
            unstash 'terraform-files'
                container('terraform') {
                    dir("vault/config/configuration"){
                       script {
                            sshagent(['qd-demo-ec2-pem']) {
                                sh "whoami"
                                env.TF_VAR_VAULT_URL = "34.255.215.129"
                                env.TF_VAR_VAULT_TOKEN = sh(script: """ssh -o StrictHostKeyChecking=no  -l ubuntu ${env.TF_VAR_VAULT_URL}  \"cat ~/root_token\"""", returnStdout: true)
                                echo "${env.TF_VAR_VAULT_TOKEN}"
                                withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "qf-aws",
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                ]]) 
                                {
                                    sh "terragrunt run-all plan --terragrunt-non-interactive"
                                }
                            }
                        }
                    }
                }
            }
            post {
            failure{
                    echo "========Pipeline execution failed========"
                }
            }
        }

        stage('Apply Vault configuration on DEV') {
            agent {
                label 'terraform:1.0'
            }
            environment {
                TF_VAR_ENV = "dev"
            }
            steps {
            unstash 'terraform-files'
              container('terraform') {
                    dir("vault/config/configuration"){
                        withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "qf-aws",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) 
                        {
                            sh "terragrunt run-all apply --terragrunt-non-interactive"
                        }
                    }
                }
            }
            post {
                cleanup {
                    cleanWs()
                }
            }
        }
    }
    // common
    post {
        always{
            echo "========always========"
        }
        success{
            echo "========Pipeline executed successfully========"
        }
        failure{
            echo "========Pipeline execution failed========"
        }
    }
}
