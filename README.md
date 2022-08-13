# Docker Environment for the development on the Rasberry Pico

## Repository Structure:
- Dockerfile: The docker file to build the ubuntu image for the development environment
- pico_setup.sh: The bash script taken from the Rasberry Pico W starter guide (Will be linked later)

Image creates succesfully and is able to compile binaries. Will be looking into remote develompent
soon to ease the use of the container.

UART not yet working in the container since it might depend on a connection to the actual hardware
on the host system (That is just a guess I am not experienced in embedded systems) But will
look into implementing that soon.

