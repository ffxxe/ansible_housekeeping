# Description

This ansible role setup systemd timer will run the script every week. It removes stopped containers, unused images, networks and cache. If they're older than a month.
But since this option is not available for volumes, they will be deleted every week regardless of the date they were created.
