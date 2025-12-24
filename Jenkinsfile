pipeline {
    agent none  // Pas d'agent par défaut
    
    stages {
        stage('Build Docker Image') {
            agent {
                kubernetes {
                    label 'docker-agent'
                    yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: agent
spec:
  containers:
  - name: docker
    image: docker:latest
    command:
    - sleep
    args:
    - 99999
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
    - name: docker-config
      mountPath: /tmp/.docker
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
  - name: docker-config
    secret:
      secretName: docker-creds
      items:
      - key: .dockerconfigjson
        path: config.json
"""
                }
            }
            steps {
                checkout scm
                container('docker') {
                    script {
                        sh '''
                            mkdir -p /root/.docker
                            cp /tmp/.docker/config.json /root/.docker/config.json
                            docker build -t kyul1234/k8s-hello-world:latest .
                            docker push kyul1234/k8s-hello-world:latest
                        '''
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            agent {
                kubernetes {
                    label 'kubectl-agent'
                    yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: agent
spec:
  serviceAccountName: jenkins
  containers:
  - name: kubectl
    image: alpine/k8s:1.28.3
    command:
    - cat
    tty: true
"""
                }
            }
            steps {
                checkout scm
                container('kubectl') {
                    script {
                        sh '''
                            kubectl apply -f hello-world.yml
                        '''
                    }
                }
            }
        }
    }
}