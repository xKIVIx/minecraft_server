FROM ubuntu:16.04

RUN apt-get update ; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget \
        default-jre-headless \
        ; \
    apt-get autoremove -y ; apt-get clean; rm /var/lib/apt/lists/* -r ; \
    rm -rf /usr/share/man/* ; \
    rm -rf /tmp/* /var/tmp/*

RUN update-ca-certificates -f

RUN useradd -ms /bin/bash minecraftserver

USER minecraftserver
WORKDIR /home/minecraftserver

RUN mkdir plugins
RUN mkdir mods

RUN wget -O server.jar https://mohistmc.com/builds/1.12.2/mohist-1.12.2-321-server.jar

# ----------------------

WORKDIR /home/minecraftserver/mods

RUN wget \
    https://media.forgecdn.net/files/2628/698/DrZharks+MoCreatures+Mod-12.0.5.jar \
    https://media.forgecdn.net/files/3081/433/DivineRPG-1.7.1.jar \
    https://media.forgecdn.net/files/3051/450/twilightforest-1.12.2-3.11.1021-universal.jar \
    https://media.forgecdn.net/files/2915/375/Chisel-MC1.12.2-1.0.2.45.jar \
    https://media.forgecdn.net/files/2902/483/TConstruct-1.12.2-2.13.0.183.jar \
    https://media.forgecdn.net/files/3174/535/conarm-1.12.2-1.2.5.10.jar \
    https://media.forgecdn.net/files/2916/2/journeymap-1.12.2-5.7.1.jar \
    https://media.forgecdn.net/files/2621/449/jei_1.12.2-4.12.1.217.jar \
    https://media.forgecdn.net/files/2747/935/ironchest-1.12.2-7.0.72.847.jar \
    https://media.forgecdn.net/files/2684/780/forestry_1.12.2-5.8.2.387.jar \
    https://media.forgecdn.net/files/3252/551/backpacked-1.4.3-1.12.2.jar \
    https://media.forgecdn.net/files/3330/934/Botania+r1.10-364.4.jar \
    https://media.forgecdn.net/files/3347/832/Decocraft-2.6.3.7_1.12.2.jar \
    https://media.forgecdn.net/files/3383/460/mcw-bridges-1.0.6b-mc1.12.2.jar \
    https://media.forgecdn.net/files/2884/962/mcw-windows-1.0.0-mc1.12.2.jar \
    https://media.forgecdn.net/files/3340/797/mcw-doors-1.0.3-mc1.12.2.jar \
    https://media.forgecdn.net/files/2879/573/mcw-roofs-1.0.2-mc1.12.2.jar \
    https://media.forgecdn.net/files/3231/561/mcw-fences-1.0.0-mc1.12.2.jar \
    https://media.forgecdn.net/files/3488/758/mcw-trapdoors-1.0.3-mc1.12.2.jar \
    https://media.forgecdn.net/files/2518/667/Baubles-1.12-1.5.2.jar \
    https://media.forgecdn.net/files/2713/386/Mantle-1.12-1.3.3.55.jar \
    https://media.forgecdn.net/files/3346/568/PTRLib-1.0.5.jar

# ----------------------

WORKDIR /home/minecraftserver/plugins

RUN wget \
    https://media.forgecdn.net/files/2820/73/AuthMe-5.6.0-SNAPSHOT.jar

# ----------------------
WORKDIR /home/minecraftserver

RUN echo eula=true > eula.txt

COPY server.properties .
RUN mkdir mohist-config
COPY mohist.yml mohist-config/
USER root
RUN chmod 777 mohist-config/mohist.yml
USER minecraftserver

CMD java -Xms4G -Xmx4G -jar server.jar
