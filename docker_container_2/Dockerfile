FROM ubuntu:20.04

WORKDIR /let1

COPY . .

RUN touch /var/log/time.log; 
RUN chmod +x let1.sh; chmod +x logging.sh;
RUN apt update; apt install -y bc;

CMD /let1/logging.sh
