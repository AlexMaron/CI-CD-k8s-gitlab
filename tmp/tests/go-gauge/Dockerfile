FROM golang:1.17-alpine3.14 AS build-stage

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

# Create appuser
ENV USER=appuser
ENV UID=10001

# See https://stackoverflow.com/a/55757473/12429735RUN 
RUN adduser \    
    --disabled-password \    
    --gecos "" \    
    --home "/nonexistent" \    
    --shell "/sbin/nologin" \    
    --no-create-home \    
    --uid "${UID}" \    
    "${USER}"

WORKDIR /app
#COPY go.mod ./
COPY gauge.go ./
RUN go mod init gauge
RUN go mod tidy

#COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" gauge.go

#STEM 2 build a small image
FROM scratch AS export-stage

# Copy user and group files
COPY --from=build-stage /etc/passwd /etc/passwd
COPY --from=build-stage /etc/group /etc/group

# Copy our static executable.
COPY --from=build-stage /app/gauge /app/gauge

EXPOSE 8000
ENTRYPOINT ["/app/gauge"]
