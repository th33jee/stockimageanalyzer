import requests
import time
import sys

# Wait for backend to be ready
print("Waiting for backend to be ready...")
time.sleep(3)

# Test the API with the test chart
print("Testing /analyze endpoint with test_chart.png...")
try:
    with open('test_chart.png', 'rb') as f:
        files = {'file': f}
        response = requests.post('http://localhost:8000/analyze', files=files, timeout=15)
        print(f'Status Code: {response.status_code}')
        print(f'Response: {response.json()}')
except requests.exceptions.ConnectionError:
    print('ERROR: Cannot connect to backend at http://localhost:8000')
    print('Make sure the backend is running!')
except Exception as e:
    print(f'Error: {type(e).__name__}: {str(e)}')
    import traceback
    traceback.print_exc()
