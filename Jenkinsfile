pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS-credentials')
        AWS_SECRET_ACCESS_KEY = credentials('AWS-credentials')
	    
       
    }


    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ramalaxmibandi/terraform-pipeline'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Plan') {
            steps {
                sh 'terraform plan -out tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Apply / Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'terraform ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
                }
            }
        }
       stage('Generate Ansible Files') {
            steps { sh "chmod +x -R ${env.WORKSPACE}"
                script {
                    // Execute the shell script
                    sh './generatefiles.sh'
                }

    }
	
}
       stage('Push to Ansible Repository') {
             steps {
                 git branch: 'main', credentialsId: '6d7c5d51-15f2-49b2-9632-61d2729ef2f6', url: 'https://github.com/ramalaxmibandi/ansible-pipeline'

                // Commit and push changes
                sh '''
                    cd  /var/jenkins_home/workspace/terra-pipeline
                    git add ansible.cfg ansible_inventory private_key.pem
                    git commit -m "Update Ansible files from Terraform"
                    git push origin main  # Or your branch name
                
	
                
            }
        }
    }
}
