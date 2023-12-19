LDFLAGS="-L/usr/local/opt/flex/lib"

run: main
	./main

main: automate.o main.o
	gcc -Wall -o main automate.o main.o

automate.o: automate.c automate.h
	gcc -c -Wall automate.c

main.o: main.c automate.h
	gcc -c -Wall main.c

main.c: regexp
	./regexp < test.1
	cat main.c


# Commenter deux des trois lignes en fonction de l'ordi
# La deuxième et la troisième est normalement pour les MAC
# La première pour les autres systèmes
# il faut éventuelleme,nt remplacer -ll par -lfl
regexp: regexp.yy.c regexp.tab.c
	gcc -o $@ $^ -ly -ll
#	gcc -o $@ $^ ${LDFLAGS} -ly -lfl
#	gcc -mmacosx-version-min=13.1 -o $@ $^ ${LDFLAGS} -ly -lfl

regexp.tab.c: regexp.y
	bison -d --report=all $^
#	bison -d -v -g $^
# -d pour générer le fichier exo01.tab.h
# -v pour générer le fichier exo01.output
# -g pour générer le fichier exo01.vcg

regexp.yy.c: regexp.l
	flex -o $@ $^

install:
	sudo apt-get install -y libbison-dev


clean:
	rm -f main
	rm -f main.c
	rm -f *.o
	rm -f *.output
	rm -f *.tab.c *.tab.h
	rm -f *.yy.c
	rm -f regexp
	rm -rf ${LADIR}
	rm -f ${LADIR}.zip
	ls -als

LADIR="IN520_Projet"
zip:
	rm -rf ${LADIR}
	mkdir ${LADIR}
	cp Makefile automate.h automate.c main.1.c ${LADIR}
#	cp regexp.l regexp.y ${LADIR}
	cp test.1 ${LADIR}
	rm -f ${LADIR}.zip
	zip -r ${LADIR}.zip ${LADIR}
	rm -rf ${LADIR}

