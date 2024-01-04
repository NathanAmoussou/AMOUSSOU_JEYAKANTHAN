LDFLAGS="-L/usr/local/opt/flex/lib"

## L'organisation des fichiers est la suivant
# 
# regexp.l -- flex --> regexp.yy.c
# regexp.y -- bison --> regexp.tab.c
# 
# regexp.yy.c + regexp.tab.c -- gcc --> regexp
# 
# test.1 -- regexp --> main.py
# 
# 
# Finalement c'est l'exécution de pyhton3 main.py qui fait ce qui est demandé
# 

run: main.py
	python3 main.py

main.py: regexp test.1
	./regexp < test.1

# Commenter deux des trois lignes en fonction de l'ordi
# La deuxième et la troisième est normalement pour les MAC
# La première pour les autres systèmes
# il faut éventuelleme,nt remplacer -ll par -lfl
regexp: regexp.yy.c regexp.tab.c
#	gcc -o $@ $^ -ly -ll
#	gcc -o $@ $^ ${LDFLAGS} -ly -lfl
	gcc -mmacosx-version-min=13.1 -o $@ $^ ${LDFLAGS} -ly -lfl

regexp.tab.c: regexp.y
	bison -d --report=all $^
#	bison -d -v -g $^
# -d pour générer le fichier exo01.tab.h
# -v pour générer le fichier exo01.output
# -g pour générer le fichier exo01.vcg

regexp.yy.c: regexp.l
	flex -o $@ $^



#
install:
	sudo apt-get install -y libbison-dev


clean:
	# Ce qui est généré par bison
	rm -f regexp.yy.c	rm -f regexp.output regexp.tab.c regexp.tab.h
	# Ce qui est généré par flex
	rm -f regexp.yy.c
	# L'exécutanle regexp
	rm -f regexp
	# Le programme main.py
	rm -f main.py
	rm -f *.zip
	ls -als

LADIR="IN520_Projet_Python"
zip_etud:
	rm -rf ${LADIR}
	mkdir ${LADIR}
# On ne recopie pas la solution
#	cp regexp.l regexp.y ${LADIR}
	cp Makefile automate.py main.1.py test.1 ${LADIR}
	rm -f ${LADIR}.zip
	zip -r ${LADIR}.zip ${LADIR}
	rm -rf ${LADIR}


LADIRcorr="IN520_Projet_Python_correction"
zip_corr:
	rm -rf ${LADIRcorr}
	mkdir ${LADIRcorr}
#	On recopie la solution
	cp regexp.l regexp.y ${LADIRcorr}
	cp Makefile automate.py main.1.py test.1 ${LADIRcorr}
	rm -f ${LADIRcorr}.zip
	zip -r ${LADIRcorr}.zip ${LADIRcorr}
	rm -rf ${LADIRcorr}


