# Use Python 3.9 base image
FROM python:3.9

# Set working directory inside the container
WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the main application
COPY app.py .

# Command to run the app
CMD ["python", "app.py"]

