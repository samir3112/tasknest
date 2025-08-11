FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]



# docker build -t tasknest-api .
# docker run -d -p 5000:5000 tasknest-api
# docker tag tasknest-api samir3112/tasknest-api:latest
# docker push samir3112/tasknest-api:latest
# docker ps
# curl http://<ip-address>
# curl http://<ip-address>/tasks
# curl -X POST http://<ip-address>/tasks -H "Content-Type: application/json" -d '{"title": "Learn Docker", "description": "Build and run containers"}'
# curl http://<ip-address>/tasks

# Install Terraform
# sudo apt update , sudo apt install awscli -y, aws configure
# sudo apt install -y gnupg software-properties-common curl  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list  sudo apt update  sudo apt install terraform -y