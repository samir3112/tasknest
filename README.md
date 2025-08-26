# 🚀 TaskNest – Flask + AWS + Terraform + GitHub Actions

TaskNest is a **ToDo API** built with Flask, deployed on AWS using Terraform, and secured with CI pipelines.  
It integrates **EC2, RDS, and S3** with Dockerized deployment and automated GitHub Actions CI.

---

## ✨ Features
- ✅ Flask REST API with CRUD operations (`/tasks`, `/tasks/<id>`)
- ✅ MySQL (AWS RDS) as backend with SQLAlchemy ORM
- ✅ Export tasks to AWS S3 as CSV (`/export`)
- ✅ Dockerized app – image pushed to DockerHub
- ✅ Terraform-managed AWS infra (VPC, EC2, RDS, S3, SGs)
- ✅ CI pipeline with Pytest, SonarCloud, and Trivy scans

---

## 🏗️ Architecture
[ GitHub ] → [ GitHub Actions CI ] → [ SonarQube ] →  [ Docker ]  → [ Trivy ] → [ DockerHub ]
                                                                                     |
[ AWS EC2 ]                                                                         <-
↓
[ Flask API ]
↓
[ AWS RDS MySQL ] [ AWS S3 Export ]

---

## ⚙️Tech Stack

Backend: Flask, SQLAlchemy

Database: AWS RDS (MySQL)

Infrastructure: Terraform (VPC, EC2, RDS, S3, SG)

CI/CD: GitHub Actions, DockerHub

Security: Trivy Scan, SonarCloud

---

## 📂 Project Structure

tasknest/
├── app/
│ ├── app.py # Flask App
│ ├── requirements.txt # Dependencies
│ └── Dockerfile # Docker Image
├── terraform/ # AWS Infra (VPC, EC2, RDS, SGs, etc.)
├── tests/
│ └── test_health.py # Pytest health checks
├── .github/workflows/ci.yml # GitHub Actions CI
├── sonar-project.properties # SonarCloud Config
└── README.md

---

🚀 Setup Instructions

1️⃣ Clone the repo
git clone https://github.com/<your-username>/tasknest.git
cd tasknest

2️⃣ Run Locally
cd app
pip install -r requirements.txt
python app.py


Visit → http://127.0.0.1:5000/

3️⃣ Build & Run with Docker
docker build -t tasknest-api ./app
docker run -p 5000:5000 tasknest-api

4️⃣ Deploy with Terraform (AWS)
cd terraform
terraform init
terraform apply -auto-approve

5️⃣ CI Pipeline

GitHub Actions (.github/workflows/ci.yml) runs on every push:

✅ Tests (pytest)

✅ Security Scan (Trivy)

✅ Docker Build & Push (DockerHub)

✅ SonarCloud Scan


📦 API Endpoints

GET / → Health check

GET /tasks → Get all tasks

POST /tasks → Create new task

GET /tasks/<id> → Get task by ID

PUT /tasks/<id> → Update task

DELETE /tasks/<id> → Delete task

GET /export → Export tasks to S3 as CSV

## 🔐 GitHub Secrets Required

| Secret Name       | Description                     |
| ----------------- | ------------------------------- |
| `DOCKER_USERNAME` | Your DockerHub username         |
| `DOCKER_PASSWORD` | Your DockerHub password/token   |
| `EC2_HOST`        | Updated via script              |
| `RDS_ENDPOINT`    | Updated via script              |
| `EC2_KEY`         | Your PEM file contents (base64) |

💡 What I Learned

Through this project, I gained hands-on experience in:

1) Flask Development – Building a production-ready REST API with CRUD operations.
2) Database Integration – Using SQLAlchemy with AWS RDS (MySQL) for persistent storage.
3) Containerization – Packaging the application into a Docker image and running it as a container.
4) Terraform for IaC – Automating infrastructure provisioning (VPC, EC2, RDS) on AWS.
5) CI/CD with GitHub Actions – Automating testing, Docker build, and deployment workflows.
6) Secrets Management – Updating and managing AWS + Docker credentials securely with GitHub Secrets.
7) AWS Deployment – Deploying and running Docker containers on EC2, connected to RDS.
8) Automation & Scalability – Reducing manual work with user_data scripts and GitHub Actions pipelines.


🚀 Challenges I Faced & How I Solved Them

Challenge 1 – Docker Image Size Too Large
The initial Docker image was bulky and slow to push.
✅ Solution – Switched to Python slim base image and added .dockerignore to exclude unnecessary files.

Challenge 2 – CI Deployment Fails
Sometimes the container wouldn’t restart properly on EC2.
✅ Solution – Added docker stop && docker rm before running the new container in the deploy script.

Challenge 3 – Terraform State Management
Running Terraform multiple times caused resource conflicts.
✅ Solution – Learned to use terraform destroy and proper remote state management with terraform init.

Challenge 4 – SonarQube Analysis Failing in CI
At first, GitHub Actions pipeline failed while running SonarQube because it needed authentication & project keys.
✅ Solution – Configured SONAR_TOKEN and SONAR_PROJECT_KEY as GitHub Secrets, updated the workflow to include SonarQube scanner plugin, and verified results on the SonarQube dashboard.

Challenge 5 – Trivy Scan Blocking Build
Trivy scan was reporting vulnerabilities and failing the pipeline, even for low/medium issues.
✅ Solution – Updated the workflow to run trivy image --exit-code 0 for non-critical issues (warnings only), and --exit-code 1 for critical vulnerabilities. This way, the pipeline only fails for high-risk problems.

Challenge 6 – Workflow Order Confusion (SonarQube vs Trivy vs Docker)
Initially I wasn’t sure whether to run SonarQube or Trivy first.
✅ Solution – Finalized the correct order:

SonarQube → Docker Build → Trivy Scan → Push to DockerHub → Deploy


## ✍️ Author

**Samir Parate**
🧑‍💻 DevOps Engineer (Fresher)

## 📄 License

This project is licensed under the MIT License.

---

## 🙌 Acknowledgments

Thanks to open-source tools and the DevOps community 🙏

---

## 🔗 Connect with Me

* GitHub: [samir3112](https://github.com/samir3112)
* LinkedIn: [Samir Parate][https://linkedin.com/in/samir-parate-devops3112]



---

