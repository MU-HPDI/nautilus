FROM nvcr.io/nvidia/pytorch:21.06-py3

# install system reqs
RUN apt update && apt install -y vim libgl-dev
RUN apt-get install --reinstall ca-certificates # for git

# env variables
ENV MPLCONFIGDIR /tmp
ENV TORCH_HOME /tmp
ENV FVCORE_CACHE /tmp


##########
# Detectron 2
#########
RUN git clone -b 'v0.4' --single-branch --depth 1 --recursive https://github.com/facebookresearch/detectron2.git /workspace/detectron2
RUN pip install -v  /workspace/detectron2/

###################################################################



# COPY (AND INSTALL) YOUR CODE TO CONTAINER HERE



####################################################################

# set the entrypoint
CMD /bin/bash
