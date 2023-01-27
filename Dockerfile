# base image to be used
FROM python:3.8
# The enviroment variable ensures that the python output is set straight
# to the terminal with out buffering it first
ENV PYTHONUNBUFFERED 1

# create root directory for our project in the container
#RUN mkdir /code

# Set the working directory to the created dir
WORKDIR /code

# add the requiremnets file to the working dir
COPY requirements.txt /code/

#instal the requirements (install before adding rest of code to avoid rerunning this at every code change-built in layers)
RUN pip3 install -r requirements.txt

# Copy the current directory contents into the container at /music_service
COPY . /code/

#set environments to be used
#set environments to be used
ENV AUTHOR="Mokgadi"

EXPOSE 8000

#run the service docker app
CMD /code/start.sh


#docker run -it -v my-vol:/code -p 8000:8000  86f3342cffa
#$ docker run --env-file env.list ubuntu env | grep VAR
#VAR1=value1
#VAR2=value2
#USER=denis