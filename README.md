# UberBus Backend


## Introduction

In this application, it will get http request from uberbus frontend. And return result from database to the client.

### WorkFlow
  - After push code to github, `github action` will first run automated testing for endpoint, then it will automatically build and push docker image to `Amazon ECR`.(CI)
  - Use terraform file to automatally config `vpc, subnet, internet_gateway, load balancer,security group` etc in the AWS cloud.
  - After pushed image to `ECR`, `github action` will use task defination file to renders new task definition for deployment in service.(CD)

### How to run locally
  - Clone the repository to your local: `git clone https://github.com/ManasaVanga/UberBusApp-NodeJs.git`.
  - Run `npm install` to install the depencency, then run `npm start`, you can run it locally.
  - Test the application at `http://localhost:3001/test`

### Run application in AWS Cloud
  - If you want to run in AWS cloud, you need to config AWS cloud environment (using terraform) and config github action, then you can push the code to github to do the CI/CD in amazon cloud.
  - Test the application at - `http://uber-bus-app-alb-148583969.us-east-1.elb.amazonaws.com/test`

### Key Functionality
  - CI/CD using AWS cloud and Github Action
  - Automate Deployment using IAC (Terraform)
  - Load Balancer
  - Application Testing as part of the CI/CD pipeline
  - Monitoring (Grafana)

### Technical stack:
Language| Framework | Platform |
| --------| --------| --------|
javascript| NodeJS | AWS cloud|
nosql      | MongoDB  | MongoDB Atlas|
terraform   | Terraform | AWS cloud|
