pipeline {
    agent any 
    stages {
        stage('checkout') {
            steps {
                git credentialsId: '698b8fc8-ca64-47f5-9b93-659da750f1a6', url: 'https://github.com/BorisFyot/projet_formation.git', branch: 'tp1'
			}
    	}
    	stage('build') {
            steps {
                sh 'mvn install'
        	}
		} 
    }
}