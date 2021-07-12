FROM python:3.7

RUN apt-get update && \
	apt-get install -y git

RUN mkdir /app /app/Slicer
WORKDIR /app

RUN wget https://download.slicer.org/bitstream/1442746
RUN tar -xf 1442746
RUN mv Slicer-4.11.20210226-linux-amd64 /app/Slicer
RUN rm -rf 1442746 \
	rm -rf Slicer-4.11.20210226-linux-amd64


