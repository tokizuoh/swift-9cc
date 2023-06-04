ssh:
	./ssh.sh -x

test:
	./test.sh

clean:
	rm -f *.o *~ tmp*

run:
	swift run swift-9cc ${ARG} > tmp.s
	echo "----"
	echo ""
	cat tmp.s
	rm tmp.s
