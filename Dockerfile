FROM debian:10.11 as source
WORKDIR /kernel

# Extra Metadata
LABEL version = "0.1.0"
LABEL desciption = "Compile A Kernel"

# Install Dependencies
FROM source as init
RUN apt update -y && apt upgrade -y
RUN apt install -y apt-utils
RUN apt install -y build-essential
RUN apt install -y gcc
RUN apt install -y libncurses-dev
RUN apt install -y gawk
RUN apt install -y flex
RUN apt install -y bison
RUN apt install -y openssl
RUN apt install -y libssl-dev
RUN apt install -y dkms
RUN apt install -y libelf-dev
RUN apt install -y libudev-dev
RUN apt install -y libpci-dev
RUN apt install -y libiberty-dev
RUN apt install -y autoconf
RUN apt install -y git 
RUN apt install -y wget
RUN apt install -y python3
RUN apt install -y python3-pip

# Install mkosi
RUN python3 -m pip install --user git+https://github.com/systemd/mkosi.git

# Fetch Kernel Sources
FROM init as fetch
RUN mkdir VM
RUN git clone https://gitlab.com/fierce-lab/linux.git

# Build root file system
RUN cd linux
#RUN cp scripts/memorizer/mkosi.default /VM
#RUN cp scripts/memorizer/mkosi.postinst /VM
#RUN cd ./VM
#RUN mkosi


# RUN wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.11.tar.xz
# RUN wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.11.tar.sign

# Build Kernel
# FROM verify as compile

# RUN tar -xvf linux-5.15.11.tar
# RUN cd linux-5.15.11 && make mrproper

# Build root file system
# RUN mkdir VM
# cp ./scripts/memorizer/mkosi.default ./VM
# cp ./scripts/memorizer/mkosi.postinst ./VM
# (cd ./VM && sudo mkosi)

# FROM compile