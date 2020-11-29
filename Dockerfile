FROM gcc:8.4

COPY setup.sh setup.sh
RUN bash setup.sh
ENV PATH="/root/miniconda3/bin:/root/.cargo/bin:/usr/bin/cmake/bin:${PATH}"

COPY pisa.sh pisa.sh
COPY scripts scripts
COPY queries queries
COPY pairs pairs

ENV WORK="/work"
ENV DATA="/data"
ENV INPUT="/input"
