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
RUN apt install -y bc
RUN apt install -y libncurses-dev
RUN apt install -y gawk
RUN apt install -y flex
RUN apt install -y bison
RUN apt install -y openssl
RUN apt install -y qemu-system
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
RUN git clone https://gitlab.com/fierce-lab/linux.git

# Build root file system
WORKDIR linux
RUN mkdir -p VM
RUN sudo cp ./scripts/memorizer/mkosi.default VM/mkosi.default
RUN cp ./scripts/memorizer/mkosi.postinst VM/mkosi.postinst
WORKDIR  VM
RUN sudo bash "/kernel/linux/scripts/memorizer/mkosi.default"


RUN wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.11.tar.xz
RUN wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.11.tar.sign

# Build Kernel
#FROM verify as compile

WORKDIR /kernel/linux/VM
RUN tar -xvf linux-5.15.11.tar.xz
WORKDIR linux-5.15.11 
RUN cp /kernel/linux/scripts/memorizer/memorizer_config.config .config 
RUN make -j$(nproc)
RUN make -j$(nproc) modules_install
WORKDIR /kernel/linux
RUN sudo ./scripts/memorizer/run_qemu.sh ./VM/rootfs.raw
# Build root file system
#RUN mkdir VM
#COPY ./scripts/memorizer/mkosi.default ./VM
#COPY ./scripts/memorizer/mkosi.postinst ./VM
#(cd ./VM && sudo mkosi)

#FROM compile
