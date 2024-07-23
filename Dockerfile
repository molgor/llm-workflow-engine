FROM python:3

ARG GROUP_ID=1000
ARG USER_ID=1000


ARG USER_NAME=juan
ARG GROUP_NAME=juan

# Create a new group with the specified group name
RUN groupadd -g ${GROUP_ID} ${GROUP_NAME}

# Create a new user with the specified user name and assign it to the group
RUN useradd -u ${USER_ID} -g ${USER_NAME} $USER_NAME


# Set the user to run the container
RUN usermod -a -G ${GROUP_ID} root
USER root

# Pkgs for default database.
RUN apt-get update && apt-get install -y sqlite3

# Editor packages.
RUN apt-get install -y vim vim-airline vim-ctrlp

COPY requirements.txt /tmp/requirements.txt

## Update pip
RUN pip install --upgrade pip

RUN pip install -r /tmp/requirements.txt

COPY . /src
WORKDIR /src

# Install LWE
RUN pip install -e .

ENV PYTHONPATH=/src:$PYTHONPATH

RUN usermod -d /root ${USER_NAME}
RUN chown -R ${USER_NAME}:${GROUP_NAME} /root
USER juan
