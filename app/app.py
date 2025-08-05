from flask import Flask, request, jsonify

app = Flask(__name__)

tasks = []
task_id = 1

@app.route('/')
def home():
    return "Welcome to TaskNest ToDo API!"

@app.route('/tasks', methods=['GET', 'POST'])
def handle_tasks():
    global task_id
    if request.method == 'POST':
        data = request.get_json()
        task = {
            'id': task_id,
            'title': data['title'],
            'description': data.get('description', ''),
            'done': False
        }
        tasks.append(task)
        task_id += 1
        return jsonify(task), 201
    return jsonify(tasks)

@app.route('/tasks/<int:id>', methods=['GET', 'PUT', 'DELETE'])
def task_by_id(id):
    task = next((t for t in tasks if t['id'] == id), None)
    if not task:
        return jsonify({'error': 'Task not found'}), 404

    if request.method == 'GET':
        return jsonify(task)
    elif request.method == 'PUT':
        data = request.get_json()
        task.update({
            'title': data.get('title', task['title']),
            'description': data.get('description', task['description']),
            'done': data.get('done', task['done'])
        })
        return jsonify(task)
    elif request.method == 'DELETE':
        tasks.remove(task)
        return jsonify({'message': 'Task deleted'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
