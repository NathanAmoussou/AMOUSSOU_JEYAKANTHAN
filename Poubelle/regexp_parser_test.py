# Question 6

# Importez vos analyseurs
from regexp_lex import lexer
from regexp_parser import parser

# Définissez une fonction de test
def test_regexp(input_string):
    # Utilisez l'analyseur lexical sur l'entrée
    lexer.input(input_string)

    # Utilisez l'analyseur syntaxique sur la même entrée
    result = parser.parse(input_string, lexer=lexer)

    # Imprimez l'arbre syntaxique résultant ou le message d'erreur
    print(result)

# Testez avec diverses expressions régulières
test_regexp("(a+b)*.E")
test_regexp("ab+c")
