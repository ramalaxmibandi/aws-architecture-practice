pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
       AWS_ACCESS_KEY = credentials('aws-accesskey')
          AWS_SECRET_ACCESS_KEY = credentials('aws-secretkey')
	 GIT_CONFIG_USERNAME = credentials('Git-config-username')
	 GIT_CONFIG_EMAIL =  credentials('Git-config-email')
	 PASSWORD = credentials('git-password')

	    
 }


    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ramalaxmibandi/terraform-pipeline'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'pwd; terraform init'
            }
        }
        stage('Plan') {
            steps {
                sh 'pwd; terraform plan -out tfplan'
                sh 'pwd; terraform show -no-color tfplan > tfplan.txt'
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
	    
       stage('git checkin') {
             steps {
                    sh 'git remote set-url origin "GIT_REPO"'
	     }
       }
	stage('push to Ansible repo') {
		steps{
                    sh 'cd  /var/lib/jenkins/workspace/terraform-pipeline'
		    sh 'git remote add origin https://github.com/ramalaxmibandi/ansi-exercise.git' 
                    sh 'git add ansible.cfg ansible_inventory private_key.pem'
		    sh 'git commit -m "adding ansible files"'
                    sh 'git push origin main'

                
	
                
            }
        }
    }
 }
