GRPC_CPP_PLUGIN = grpc_cpp_plugin
GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`

PROTOS_PATH = grpc

vpath %.proto $(PROTOS_PATH)

all: gen_c gen_go

gen_c: fpcp.grpc.pb.cc fpcp.pb.cc

gen_go: fpcp.pb.go

%.pb.go: %.proto
	protoc -I $(PROTOS_PATH) --go_out=plugins=grpc:./go/ $<

%.grpc.pb.cc: %.proto
	protoc -I $(PROTOS_PATH) --grpc_out=./cpp/ --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<

%.pb.cc: %.proto
	protoc -I $(PROTOS_PATH) --cpp_out=./cpp/ $<

clean:
	rm -f ./cpp/*.pb.cc ./cpp/*.pb.h ./go/*.pb.go
