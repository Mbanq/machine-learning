FROM amazonlinux:2

RUN yum install gcc openssl-devel bzip2-devel libffi-devel make tar gzip docker -q -y

# DOWNLOAD PYTHON
WORKDIR /usr/src
RUN curl https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz -o python.tgz
RUN tar xzf python.tgz

# COMPILE PYTHON
WORKDIR Python-3.7.3
RUN ./configure --enable-optimizations
RUN make altinstall

# REMOVE PYTHON
WORKDIR /usr/src
RUN rm python.tgz

# INSTALL NODE
RUN curl --silent --location https://rpm.nodesource.com/setup_10.x | bash -
RUN yum -y install nodejs

# INSTALL SERVERLESS
RUN npm install -g serverless

# CONFIGURE SERVERLESS
RUN serverless config credentials --provider aws --key  --secret

# INSTALL VIRTUAL ENV
RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN python3.7 get-pip.py --user


# EXAMPLE
WORKDIR /home/tmp
COPY . .

# VENV
RUN pip3.7 install virtualenvwrapper
RUN virtualenv venv --python=python3.7
RUN source venv/bin/activate


# PACKAGING PYTHON WITH PLUGGINS
RUN pip3.7 install -r requirements.txt
