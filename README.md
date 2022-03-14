**This is the Repo that contains all config for Jenkins**  

To have communication with locally running minikube instance Dockerfile requires `config` file.
The config file needs to be populated with `certificate-authority-data`, `client-certificate-data`, `client-certificate-key`  data the location of which can be found by running `$ cat ~/.kube/config` in the local machine.

To create a running Jenkins container:
run:
```bash
$ docker build -t phonebookapp-jenkins:v1 .
$ docker container run -d -p 8080:8080 --network=minikube -v jenkins_home:/var/jenkins_home -v //var/run/docker.sock:/var/run/docker.sock  --name phonebookapp-jenkins phonebook-jenkins:v1
```

Jenkins environment also requires docker-hub registry username and password to be registered as secrets in Jenkins server. It will use it in pipelines to access registry.  

Jenkins environment itself should contain 4 pipelines that needs to be runned (after configuration) in the given order.

1. **kubernetes presetup** pipeline - This pipeline will create the Kubernetes **namespace**, will deploy the **backend**, **frontend** and **db** services along with **secrets** that is used by the application. The Jenkinsfile for this pipeline is located in `step-kubernetes` repository with the name **Jankinsfile.presetup**. The pipeline requires following parameters:
    * `POSTGRES_USER` - the value that will be used as PG username in secrets yaml file.
    * `POSTGRES_PASSWORD` - the value that will be used as PG password in secrets yaml file
    * `POSTGRES_DB` - the value that will be used as PG database name in secrets yaml file.

2. **db setup** pipeline - This pipeline will create the docker image for the postgres db and will upload it to a docker-hub registry. The Jenkinsfile for this pipeline is located in `step-backend` repository with the name **Jenkinsfile.db**. The pipeline requires following parameters:
    * `REGISTRY_NAME` - the registry name for docker hub for which Jenkins need to create image
    * `IMAGE_NAME` - the name of image
    * `IMAGE_TAG`  - the tag of image

3. **backend setup** pipeline - This pipeline will create the docker image for the application backend and will upload it to a docker-hub registry. The Jenkinsfile for this pipeline is located in `step-backend` repository with the name **Jenkinsfile**. The pipeline requires following paramaters:
    * `REGISTRY_NAME` - the registry name for docker hub for which Jenkins need to create image
    * `IMAGE_NAME` - the name of image
    * `IMAGE_TAG`  - the tag of image

4. **frontend setup** pipeline - This pipeline will create the docker image for the application frontend and will upload it to a docker-hub registry. The Jenkinsfile for this pipeline is located in `step-frontend` repository with the name **Jenkinsfile**. The pipeline requires following paramaters:
    * `REGISTRY_NAME` - the registry name for docker hub for which Jenkins need to create image
    * `IMAGE_NAME` - the name of image
    * `IMAGE_TAG`  - the tag of image
    * `BACKEND_SERVICE_NAME` - the name of service configured for backend templates . Since this app uses React as front-end framework it needs to have environtment variables set before building the app, so having backend service name here is rather mandatory (I did not have other choise).  
5. **kubernetes final setup** pipeline - This pipeline will create the **deployments** for the Kubernetes cluster. The repository for the pipeline is located in `step-kubernetes` repository with the name **Jankinsfile**.
    * `DB_SERVICE_NAME` - the name of service configured for db templates
    * `FRONTEND_IMAGE_NAME` - the name of frontend image
    * `BACKEND_IMAGE_NAME`  - the name of backend image
    * `DB_IMAGE_NAME` - the name of db image


