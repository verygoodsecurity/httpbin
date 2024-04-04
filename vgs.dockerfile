FROM python:3.11-bookworm as builder

RUN apt-get update
RUN apt-get install -y gcc python3-dev libffi-dev musl-dev git

WORKDIR /build
ADD ./requirements.txt /build/requirements.txt
RUN pip install -r requirements.txt
COPY . /build/

FROM 190066226418.dkr.ecr.us-east-1.amazonaws.com/base/python3:20231103-28155b78 as main

ADD . /httpbin
WORKDIR /httpbin

COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/dist-packages
COPY --from=builder /usr/local/bin/gunicorn /usr/local/bin/

EXPOSE 8000

CMD ["/usr/local/bin/gunicorn","-b","0.0.0.0:8000","-w","4","-k","gevent","httpbin:app"]
