import os
import tempfile
from flask import Flask, request, jsonify
from main import readReceipt

app = Flask(__name__)

#Uses flask to communicate with flutter
@app.route("/read-receipt", methods=['POST'])
def read_receipt():
    if 'image' not in request.files:
        return jsonify({'error': 'No image part'}), 400

    file = request.files['image']
    if file.filename == '':
        return jsonify({'error': 'No selected image'}), 400

    if file:
        temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=".png")
        
        try:
            file.save(temp_file.name)
            result = readReceipt(temp_file.name)
            return jsonify(result), 200
        finally:
            temp_file.close()
            os.unlink(temp_file.name)

if __name__ == '__main__':
    app.run()