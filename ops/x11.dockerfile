FROM debian:buster-slim

#copied from https://github.com/mviereck/dockerfile-x11docker-xfce/blob/master/Dockerfile to update
RUN apt-get update && apt-mark hold iptables && \
     env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      dbus-x11 \
      psmisc \
      xdg-utils \
      x11-xserver-utils \
      x11-utils && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      xfce4 && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libgtk-3-bin \
      libpulse0 \
      mousepad \
      xfce4-notifyd \
      xfce4-taskmanager \
      xfce4-terminal && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      xfce4-battery-plugin \
      xfce4-clipman-plugin \
      xfce4-cpufreq-plugin \
      xfce4-cpugraph-plugin \
      xfce4-diskperf-plugin \
      xfce4-datetime-plugin \
      xfce4-fsguard-plugin \
      xfce4-genmon-plugin \
      xfce4-indicator-plugin \
      xfce4-netload-plugin \
      xfce4-places-plugin \
      xfce4-sensors-plugin \
      xfce4-smartbookmark-plugin \
      xfce4-systemload-plugin \
      xfce4-timer-plugin \
      xfce4-verve-plugin \
      xfce4-weather-plugin \
      xfce4-whiskermenu-plugin \
    && env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libxv1 \
      mesa-utils \
      mesa-utils-extra \
    && apt-get clean  \
    && sed -i 's%<property name="ThemeName" type="string" value="Xfce"/>%<property name="ThemeName" type="string" value="Raleigh"/>%' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml 

# disable xfwm4 compositing if X extension COMPOSITE is missing
RUN echo "#! /bin/bash\n\
xdpyinfo | grep -q -i COMPOSITE || {\n\
  mkdir -p /home/lauscher/.config/xfce4/xfconf/xfce-perchannel-xml\n\
  echo '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n\
<channel name=\"xfwm4\" version=\"1.0\">\n\
\n\
  <property name=\"general\" type=\"empty\">\n\
    <property name=\"use_compositing\" type=\"bool\" value=\"false\"/>\n\
  </property>\n\
</channel>\n\
' > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml\n\
}\n\
startxfce4\n\
" > /usr/local/bin/start && \
chmod +x /usr/local/bin/start

CMD ["/usr/local/bin/start"]