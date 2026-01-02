# Use a slim version of Python for a smaller image size
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies for Matplotlib and Notify-send
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file first (to use Docker cache)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Run the script when the container starts
CMD ["python", "log-analisys.py"]
