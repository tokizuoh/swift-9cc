ssh:
	./ssh.sh -x

test:
	./test.sh

clean:
	rm -f *.o *~ tmp*

run:
	cat *.swift > main.swift
	swift main.swift ${ARG}
	rm main.swift
