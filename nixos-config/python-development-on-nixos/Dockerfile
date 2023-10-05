FROM python:3.11

RUN apt-get install wget

WORKDIR /app

COPY requirements.txt /app/requirements.txt

RUN pip install --upgrade pip

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Copy the current directory contents into the container at /app
COPY . /app
