# Create Python environment
FROM ubuntu:18.04
ENV LANG C.UTF-8

ARG user
ARG login_account
ARG login_password
ARG bucket_name

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y python python-dev python3 python3-dev python3-pip virtualenv libssl-dev libpq-dev git build-essential libfontconfig1 libfontconfig1-dev nano cron

# Install and update Instagram Private API
RUN pip3 install git+https://git@github.com/ping/instagram_private_api.git@1.6.0 --upgrade
RUN pip3 install git+https://git@github.com/ping/instagram_private_api.git --upgrade --force-reinstall

# Install AWS CLI
RUN pip3 install awscli --upgrade

# Download python script
RUN git clone https://github.com/notcammy/PyInstaStories.git

# Set default directory to /PyInstaStories
WORKDIR /PyInstaStories

# Create a shell script
RUN echo python3 pyinstastories.py --download $user --username $login_account --password $login_password --taken-at > run.sh
RUN echo aws s3 sync stories/$user/ s3://$bucket_name >> run.sh

# Give execution rights on the script
RUN chmod a+x run.sh

# Create cron job
# Use printf instead of echo. Idk why echo always shows :0: bad minute
RUN printf '* * * * * /PyInstaStories/run.sh\n#An empty line is required at the end of this file for a valid cron file.' > /etc/cron.d/cron_job

# Give execution rights on the cron job
RUN chmod a+x /etc/cron.d/cron_job

# Apply cron job
RUN crontab /etc/cron.d/cron_job

# Run the command on container startup
CMD cron
