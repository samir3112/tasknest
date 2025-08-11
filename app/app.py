from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

app = Flask(__name__)

# Load DB credentials from env vars
db_user = os.getenv("DB_USER")
db_pass = os.getenv("DB_PASS")
db_host = os.getenv("DB_HOST")
db_name = os.getenv("DB_NAME")

# SQLAlchemy connection string
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{db_user}:{db_pass}@{db_host}/{db_name}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Model
class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.String(500))
    done = db.Column(db.Boolean, default=False)


@app.route('/')
def home():
    return "Welcome to TaskNest ToDo API with RDS!"

@app.route('/tasks', methods=['GET', 'POST'])
def tasks_route():
    if request.method == 'POST':
        data = request.get_json()
        task = Task(title=data['title'], description=data.get('description', ''))
        db.session.add(task)
        db.session.commit()
        return jsonify({
            'id': task.id,
            'title': task.title,
            'description': task.description,
            'done': task.done
        }), 201
    else:
        tasks = Task.query.all()
        return jsonify([{
            'id': t.id,
            'title': t.title,
            'description': t.description,
            'done': t.done
        } for t in tasks])

@app.route('/tasks/<int:id>', methods=['GET', 'PUT', 'DELETE'])
def task_detail(id):
    task = Task.query.get_or_404(id)
    if request.method == 'GET':
        return jsonify({
            'id': task.id,
            'title': task.title,
            'description': task.description,
            'done': task.done
        })
    elif request.method == 'PUT':
        data = request.get_json()
        task.title = data.get('title', task.title)
        task.description = data.get('description', task.description)
        task.done = data.get('done', task.done)
        db.session.commit()
        return jsonify({'message': 'Task updated'})
    elif request.method == 'DELETE':
        db.session.delete(task)
        db.session.commit()
        return jsonify({'message': 'Task deleted'})

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True, host="0.0.0.0")
