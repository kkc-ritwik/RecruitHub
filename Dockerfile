# Build stage
FROM maven:3.8.4-openjdk-17 AS builder

WORKDIR /app

# Copy only pom.xml first for better caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Runtime stage
FROM gcr.io/distroless/java17:nonroot

WORKDIR /app

# Copy the jar from builder stage
COPY --from=builder /app/target/*.jar app.jar


EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]