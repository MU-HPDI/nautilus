FROM python:3.8

RUN pip install --upgrade pip

RUN mkdir -p /workspace
WORKDIR /workspace

COPY /requirements.txt /workspace

RUN pip install -r ./requirements.txt && rm requirements.txt

COPY /*.py /workspace/

CMD /bin/bash

