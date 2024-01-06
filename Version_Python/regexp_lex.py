# Question 2

import ply.lex as lex

# Définition des tokens avec leurs numéros uniques
tokens = [
    'PAR_O',      # Parenthèse ouvrante '('
    'PAR_F',      # Parenthèse fermante ')'
    'PLUS',       # Opérateur '+'
    'DOT',        # Opérateur '.'
    'STAR',       # Opérateur '*'
    'EPSILON',    # Epsilon 'E'
    'EMPTY_SET',  # Ensemble vide 'O'
    'LETTER'      # Lettres minuscules de 'a' à 'z'
]

# Règles d'expression régulière pour les tokens simples
t_PAR_O = r'\('
t_PAR_F = r'\)'
t_PLUS = r'\+'
t_DOT = r'\.'
t_STAR = r'\*'
t_EPSILON = r'E'
t_EMPTY_SET = r'O'

# Une règle pour reconnaître les lettres minuscules (lettres de 'a' à 'z')
def t_LETTER(t):
    r'[a-z]'
    t.type = 'LETTER'  # définit le type de token
    return t

# Compteur de ligne
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# Une chaîne contenant des caractères ignorés (espaces et tabulations)
t_ignore = ' \t'

# Règle de gestion des erreurs
def t_error(t):
    print(f"Caractère illégal '{t.value[0]}'")
    t.lexer.skip(1)

# Construire l'analyseur lexical
lexer = lex.lex()

# Testons l'analyseur lexical
data = '''
(a+b)*.E$
'''

# Donner à l'analyseur lexical une entrée
lexer.input(data)

# Tokeniser
for tok in lexer:
    print(tok)
