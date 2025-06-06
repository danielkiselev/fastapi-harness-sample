# Use an official lightweight Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Set environment variables
# This prevents Python from buffering stdout and stderr, which makes logs appear in real-time
ENV PYTHONUNBUFFERED=1

# Copy the dependency requirements file first
# This layer is cached and will only be re-run if requirements.txt changes
COPY requirements.txt requirements.txt

# Install any needed packages specified in requirements.txt
# --no-cache-dir: Disables the cache, which reduces the image size
# --upgrade: Ensures pip is up-to-date
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy the application code into the container
# This will copy the 'app' directory from your local machine to the '/app/app' directory in the container
COPY ./app /app/app

# Make port 80 available to the world outside this container
EXPOSE 80

# Define the command to run your application
# This command starts the Uvicorn server, which will serve your FastAPI application.
# --host 0.0.0.0 is crucial for making the container accessible from the host machine.
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
