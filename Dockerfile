FROM ubuntu:latest
MAINTAINER Jose Rodriguez <jrodriguezr@protonmail.com>
LABEL Description="Eclipse Oxygen + GNU ARM Eclipse Plugin + GNU ARM GCC"
ENV TZ=Europe/Madrid
#ADD . /work

# Install any needed packages specified in requirements.txt
RUN echo "Europe/Madrid" > /etc/timezone && ln -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime && \
    apt update && \
    apt upgrade -y && \
    apt install -y \
	build-essential \
	sudo \
	vim-nox \
	git \
	python-minimal \
	python3 \
	python-pip \
	bzip2 \
	wget \
	flex \
	openjdk-8-jdk \
	bison && apt clean && cd /usr/local/ && wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2 -O cortex_m.tar.bz2 && tar -xjf cortex_m.tar.bz2 && rm cortex_m.tar.bz2 && wget http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/technology/epp/downloads/release/oxygen/2/eclipse-cpp-oxygen-2-linux-gtk-x86_64.tar.gz -O eclipse.tar.gz && tar zxvf eclipse.tar.gz && rm eclipse.tar.gz

# GNUARM Eclipse Plugin Installation
	RUN /usr/local/eclipse/eclipse -noSplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/releases/oxygen/ -installIU org.eclipse.cdt.debug.gdbjtag.feature.group
	RUN /usr/local/eclipse/eclipse -noSplash -application org.eclipse.equinox.p2.director -repository http://download.eclipse.org/tools/cdt/releases/9.4 -uninstallIU "org.eclipse.cdt.feature.group, org.eclipse.cdt.launch.remote.feature.group, org.eclipse.cdt.build.crossgcc.feature.group, org.eclipse.cdt.debug.gdbjtag.feature.group, org.eclipse.cdt.gdb.feature.group, org.eclipse.cdt.autotools.feature.group, org.eclipse.cdt.debug.ui.memory.feature.group, org.eclipse.cdt.debug.standalone.feature.group" -installIU "org.eclipse.cdt.feature.group, org.eclipse.cdt.launch.remote.feature.group, org.eclipse.cdt.build.crossgcc.feature.group, org.eclipse.cdt.debug.gdbjtag.feature.group, org.eclipse.cdt.gdb.feature.group, org.eclipse.cdt.autotools.feature.group, org.eclipse.cdt.debug.ui.memory.feature.group, org.eclipse.cdt.debug.standalone.feature.group"
	RUN /usr/local/eclipse/eclipse -noSplash -application org.eclipse.equinox.p2.director -repository http://gnu-mcu-eclipse.netlify.com/v4-neon-updates/ -installIU "ilg.gnumcueclipse.templates.cortexm.feature.feature.group, ilg.gnumcueclipse.debug.gdbjtag.jlink.feature.feature.group, ilg.gnumcueclipse.templates.cortexm.feature.feature.group, ilg.gnumcueclipse.doc.user.feature.feature.group, ilg.gnumcueclipse.packs.feature.feature.group, ilg.gnumcueclipse.templates.sifive.feature.feature.group, ilg.gnumcueclipse.debug.gdbjtag.openocd.feature.feature.group, ilg.gnumcueclipse.managedbuild.cross.riscv.feature.feature.group, ilg.gnumcueclipse.templates.ad.feature.feature.group, ilg.gnumcueclipse.debug.gdbjtag.qemu.feature.feature.group, ilg.gnumcueclipse.templates.freescale.feature.feature.group, ilg.gnumcueclipse.templates.stm.feature.feature.group, ilg.gnumcueclipse.debug.gdbjtag.pyocd.feature.feature.group, ilg.gnumcueclipse.codered.feature.feature.group, ilg.gnumcueclipse.managedbuild.cross.arm.feature.feature.group"
# Darkest Theme
#	RUN /usr/local/eclipse/eclipse -noSplash -application org.eclipse.equinox.p2.director -repository https://www.genuitec.com/updates/webclipse/oxygen/ -installIU com.genuitec.eclipse.theming.feature.feature.group

## ---- user: developer ----
ENV USER_NAME=developer
ENV HOME=/home/${USER_NAME}

RUN export DISPLAY=${DISPLAY} && \
    useradd ${USER_NAME} && \
    export uid=${USER_ID} gid=${GROUP_ID} && \
    mkdir -p ${HOME} && \
    mkdir -p ${HOME}/workspace && \
    mkdir -p /etc/sudoers.d && \
    echo "${USER_NAME}:x:${USER_ID}:${GROUP_ID}:${USER_NAME},,,:${HOME}:/bin/bash" >> /etc/passwd && \
    echo "${USER_NAME}:x:${USER_ID}:" >> /etc/group && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER_NAME} && \
    chmod 0440 /etc/sudoers.d/${USER_NAME} && \
    chown ${USER_NAME}:${USER_NAME} -R ${HOME}

WORKDIR ${HOME}

ENV PATH "/usr/local/gcc-arm-none-eabi-7-2018-q2-update/bin:$PATH"
#RUN pip install mbed-cli && mbed toolchain -G GCC_ARM
