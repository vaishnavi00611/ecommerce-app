FROM openjdk:11
WORKDIR /app
COPY ./backend /app  # Adjusted the path to copy the 'backend' directory from the build context
RUN javac src/Main.java
CMD ["java", "src.Main"]
