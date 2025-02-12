FROM ubuntu:16.04

RUN apt-get update ; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget \
        vim \
        default-jre-headless \
        ; \
    apt-get autoremove -y ; apt-get clean; rm /var/lib/apt/lists/* -r ; \
    rm -rf /usr/share/man/* ; \
    rm -rf /tmp/* /var/tmp/*

RUN update-ca-certificates -f

RUN useradd -ms /bin/bash minecraftserver

USER minecraftserver
WORKDIR /home/minecraftserver

RUN mkdir mods

RUN wget -O server.jar https://mohistmc.com/builds/1.12.2/mohist-1.12.2-321-server.jar

# ----------------------

WORKDIR /home/minecraftserver/mods

RUN wget \
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
    https://media.forgecdn.net/files/2518/667/Baubles-1.12-1.5.2.jar \
    https://media.forgecdn.net/files/2713/386/Mantle-1.12-1.3.3.55.jar \
    https://media.forgecdn.net/files/3346/568/PTRLib-1.0.5.jar \
    https://media.forgecdn.net/files/2450/734/AIImprovements-1.12-0.0.1b3.jar \
    https://media.forgecdn.net/files/2687/757/railcraft-12.0.0.jar \
    https://media.forgecdn.net/files/3484/394/Roots-1.12.2-3.1.4.jar \
    https://media.forgecdn.net/files/3460/961/mysticalworld-1.12.2-1.11.0.jar \
    https://media.forgecdn.net/files/3162/874/Patchouli-1.0-23.6.jar \
    https://media.forgecdn.net/files/3483/816/mysticallib-1.12.2-1.13.0.jar \
    https://media.forgecdn.net/files/3204/475/buildcraft-all-7.99.24.8.jar \
    https://media.forgecdn.net/files/3078/604/industrialcraft-2-2.8.221-ex112.jar \
    https://media.forgecdn.net/files/2629/23/Thaumcraft-1.12.2-6.1.BETA26.jar

# ----------------------

RUN mkdir /home/minecraftserver/plugins
WORKDIR /home/minecraftserver/plugins

ADD plugins/AutoSaveWorld .

RUN wget \
    https://media.forgecdn.net/files/2820/73/AuthMe-5.6.0-SNAPSHOT.jar \
    https://media.forgecdn.net/files/2365/294/AutoSaveWorld.jar

# ----------------------
WORKDIR /home/minecraftserver

RUN echo eula=true > eula.txt

ADD server.properties .
RUN mkdir mohist-config
ADD mohist.yml mohist-config/

ENV MAX_RAM=6
ENV MIN_RAM=3

USER root
RUN chown -R minecraftserver *
USER minecraftserver

CMD java -Xms${MIN_RAM}G -Xmx${MAX_RAM}G -jar server.jar
