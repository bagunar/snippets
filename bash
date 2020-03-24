## kill process on 127.0.0.1:5000
kill -9 $(netstat -lnp | grep 'tcp .*127.0.0.1:5000' | sed -e 's/.*LISTEN *//' -e 's#/.*##')"
