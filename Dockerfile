FROM debian:9.5-slim

# Update
RUN apt-get update

# Install packages
RUN apt-get -yq install rsync openssh-client


# Label
LABEL "com.github.actions.name"="Deploy application using rsync"
LABEL "com.github.actions.description"="For deploying Zovolt applications a web or application server via rsync over ssh"
LABEL "com.github.actions.icon"="truck"
LABEL "com.github.actions.color"="yellow"

LABEL "repository"="https://github.com/streembit/apps-deploy-action"

# Copy entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
