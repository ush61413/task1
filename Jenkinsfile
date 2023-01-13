pipeline {
    agent any
    parameters {
        choice(name: 'Helm_Action', choices: ['Install/Upgrade deployment', 'UnInstall Deployment'], description: 'Helm action to perform')
        string(name: 'K8s_NAMESPACE', defaultValue: 'avi')
        string(name: 'APP_Name', defaultValue: 'my-app-avi')
//        string(name: 'APP_Version', defaultValue: "0.0.0")
    }
    environment {
        VAR1=""
        VAR2=""
    }
    stages {
        stage ('Setup Environment') {
            steps {
                script {
                    echo "Setting kube config for this run"
                    sh '''
					export KUBECONFIG=/var/lib/jenkins/.kube/config
					kubelogin convert-kubeconfig -l msi
                    '''
                }    
            }
       }    
//        stage ('Clone repo') {
//            steps {
//                checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: '**']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ush61413/task1.git']]]
//            }
//        }
        stage ('Helm Opearations') {
			steps{
				script {
					echo "Route..."
					switch(params.Helm_Action) {
					    case "Install/Upgrade deployment" : HelmDeploy(params.APP_Name, params.APP_Version, params.K8s_NAMESPACE) ; break
					    case "UnInstall Deployment" : HelmUninstall(params.APP_Name, params.K8s_NAMESPACE) ; break
					}
				}
			}
        }        
    }
}

def HelmDeploy(APP_Name,APP_Version,NAMESPACE) {
    checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: 'dev']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/ush61413/task1.git']]]
    echo "Starting Deploy App ${APP_Name} in ${NAMESPACE} NameSpace"
    sh "ls -l"
    sh "helm upgrade  ${APP_Name} ${APP_Name}/ --namespace ${NAMESPACE} --install --wait"
}

def HelmUninstall(APP_Name,NAMESPACE) {
    echo "About to Uninstall App ${APP_Name}"
    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh "helm uninstall -n ${NAMESPACE} ${APP_Name}"
                }
    
}
