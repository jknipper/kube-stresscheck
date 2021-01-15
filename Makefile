TARGET = kube-stresscheck
GOTARGET = github.com/jknipper/$(TARGET)
REGISTRY ?= keppel.eu-de-1.cloud.sap/ccloud
VERSION ?= 0.0.2
DOCKER ?= docker

all: container

container:
	$(DOCKER) build --network=host -t $(REGISTRY)/$(TARGET):latest -t $(REGISTRY)/$(TARGET):$(VERSION) .

push:
	$(DOCKER) push $(REGISTRY)/$(TARGET):latest
	$(DOCKER) push $(REGISTRY)/$(TARGET):$(VERSION)

.PHONY: all local container push

clean:
	rm -f $(TARGET)
	$(DOCKER) rmi $(REGISTRY)/$(TARGET):latest
	$(DOCKER) rmi $(REGISTRY)/$(TARGET):$(VERSION)