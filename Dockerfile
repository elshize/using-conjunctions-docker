FROM gcc:8.3

COPY setup.sh setup.sh
RUN bash setup.sh
ENV PATH="/root/miniconda3/bin:/root/.cargo/bin:/usr/bin/cmake/bin:${PATH}"

COPY pisa.sh pisa.sh
COPY intersect.sh intersect.sh
COPY scripts scripts

ENV WORK="/work"
ENV DATA="/data"
ENV INPUT="/input"
