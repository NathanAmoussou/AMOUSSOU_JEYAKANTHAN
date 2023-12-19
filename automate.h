//
// Structures de données pour stocker des automates
// Fonctions sur les automates
// qst novembre 2023
//



// Par défaut l'alphabet est l'ensemble des minuscules de 'a' à 'z'
// Les epsilon-transitions sont le caractère 0 pour le stockage et 'E' pour l'affichage
#define epsilon 0
#define affcar(x)((x)?x:'E')

struct transition { // Transition de l'état p vers l'état q avec la lettre a
	unsigned int p;
	char a;
	unsigned int q;
	struct transition *suiv;
};


struct automate {
		char *nom; // Nom de l'automate
		int N;     // Nombre d'états
				   // l'état initial est toujours l'état de numéro 0
		int *F;    // Tableau de taille N de booléens : 1 état final, 0 état non final
		int nb_trans; // Nombre de transitions
		struct transition *T; // Liste chaînée de nb_trans transitions
	};
typedef struct automate AUTOMATE;


// Affiche l'utomate A
void afficher (AUTOMATE A);

// Crée d'un automate avec N états et sans transition
AUTOMATE creer_automate (char *nom, int N);

// Crée d'un automate reconnaissant que le mot de une lettre c
AUTOMATE creer_automate_une_lettre(char c);

// Opération de base sur les automates
AUTOMATE union_automate (AUTOMATE A, AUTOMATE B);
AUTOMATE concat_automate (AUTOMATE A, AUTOMATE B);
AUTOMATE etoile_automate (AUTOMATE A);

// Opérations de modification d'un automate
AUTOMATE supprime_epsilon_transitions (AUTOMATE A);
AUTOMATE determinise (AUTOMATE A);
AUTOMATE minimise (AUTOMATE A);


int reconnait (AUTOMATE A, char *mot);
