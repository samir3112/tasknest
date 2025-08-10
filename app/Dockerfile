FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000
CMD ["python", "app.py"]


# docker build -t tasknest-api .
# docker run -d -p 5000:5000 tasknest-api
# docker tag tasknest-api samir3112/tasknest-api:latest
# docker push samir3112/tasknest-api:latest
# docker ps
# curl http://localhost:5000/
# curl http://localhost:5000/tasks
# curl -X POST http://localhost:5000/tasks -H "Content-Type: application/json" -d '{"title": "Learn Docker", "description": "Build and run containers"}'
# curl http://localhost:5000/tasks

# Install Terraform
# sudo apt update , sudo apt install awscli -y, aws configure
# sudo apt install -y gnupg software-properties-common curl  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list  sudo apt update  sudo apt install terraform -y