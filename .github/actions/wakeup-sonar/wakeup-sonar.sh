#!/bin/bash

# Wake up sonar instance if it is behind a sablier middleware proxied with cloudflare (no hang possible)
# First, curl the sonar instance to see if it is up

STATUS=$(curl -s -o /dev/null -w "%{http_code}" $SONAR_INSTANCE_URL)

if [ $STATUS -ne 200 ]; then
  echo "Sonar is down, waking it up"
  # Try to curl 6 times with 10 secondes interval before giving up
    for i in {1..6}
    do
      echo "Trying to wake up sonar, attempt $i"
      NEW_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $SONAR_INSTANCE_URL)
      if [ $NEW_STATUS -eq 200 ]; then
        echo "Sonar is up"
        exit 0
        break
      fi
      sleep 10
    done
else
  echo "Sonar is up"
  exit 0
fi
exit 1