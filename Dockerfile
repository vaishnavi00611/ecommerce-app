FROM openjdk:11
WORKDIR /app
COPY backend /app
RUN javac src/Main.java
CMD ["java", "src.Main"]
