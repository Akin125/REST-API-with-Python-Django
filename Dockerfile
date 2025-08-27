# Base image: Python 3.9 on Alpine Linux 3.13 (lightweight) (We start with a small version of Python to build our app)
FROM python:3.9-alpine3.13

# Set maintainer information (This says who made this container)
LABEL maintainer="Akin125 philipoluseyi@gmail.com"

# Make Python output directly to console (no buffering) (This makes Python show messages right away instead of waiting)
ENV PYTHONUNBUFFERED=1

# Copy project requirements file (We copy our shopping list of things our app needs)
COPY ./requirements.txt /tmp/requirements.txt

COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy application code (We copy our actual app code into the container)
COPY ./app /app

# Set the working directory (We tell the container which folder to use as our main workspace)
WORKDIR /app

# Declare that this container will use port 8000 (We tell the container to open door number 8000 for visitors)
EXPOSE 8000

# it is been overrode in the compose file
ARG DEV=false
# Setup environment:
# 1. Create a virtual environment (We create a special room for our Python stuff)
# 2. Update pip (We update our tool that installs other tools)
# 3. Install required Python packages (We install everything from our shopping list)
# 4. Clean up temporary files (We clean up our mess after installing)
# 5. Create a non-root user for security (We create a regular user instead of using the powerful admin)
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
      then  /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Add the virtual environment's bin directory to PATH (We tell the container where to find our Python tools)
ENV PATH="/py/bin:$PATH"

# Switch to non-root user for better security (We switch to our regular user for safety, like not playing with scissors)
USER django-user
