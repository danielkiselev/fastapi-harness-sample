# Start with a lightweight Python base image.
# Using a specific version like 3.11-slim is a good practice for reproducibility.
FROM python:3.11-slim

# Set the working directory inside the container to /app.
# All subsequent commands (like COPY, RUN, CMD) will be executed from this directory.
WORKDIR /app

# This environment variable ensures that Python output is sent straight to the terminal
# without being buffered first, which is useful for viewing logs in real-time.
ENV PYTHONUNBUFFERED=1

# Copy the requirements.txt file into the container.
# We copy this file separately to take advantage of Docker's layer caching.
# The `pip install` step will only be re-run if this file changes.
COPY requirements.txt requirements.txt

# Install the Python dependencies specified in requirements.txt.
# --no-cache-dir reduces the image size by not storing the download cache.
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application's code into the working directory of the container.
# This assumes your FastAPI code is in a local directory named 'app'.
COPY ./app /app/app

# Expose port 80. This informs Docker that the container listens on this port.
# This matches the containerPort in your Kubernetes manifest.
EXPOSE 8080

# The command to run when the container starts.
# This starts the Uvicorn server to run your FastAPI application.
# --host 0.0.0.0 makes the server accessible from outside the container.
# --port 80 tells Uvicorn to listen on the port we exposed.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
