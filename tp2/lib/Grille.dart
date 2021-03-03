class Grille {
  List<List<int>> grille;
  int taille;
  int ligne0;
  int colonne0;

  /* Constructeur */
  Grille(List<List<int>> g) {
    this.grille = g;
    this.taille = g.length;

    for (int i = 0; i < g.length; i++) {
      for (int j = 0; j < g.length; j++) {
        if (g[i][j] == 0) {
          this.ligne0 = i;
          this.colonne0 = j;
        }
      }
    }
  }

  /* Méthodes */

  /* function getGrille() : Retourne la grille */

  List<List<int>> getGrille() {
    return this.grille;
  }

  /* function getTaille() : Retourne la Taille de la grille */

  int getTaille() {
    return this.taille;
  }

  /* function getLigne0() : Retourne l'indice de la ligne qui contient 0 */

  int getLigne0() {
    return this.ligne0;
  }

  /* function getColonne0() : Retourne l'indice de la colonne qui contient 0 */
  int getColonne0() {
    return this.colonne0;
  }

  /* function getValeur(int i,int j) : Retourne la valeur de la case qui se trouve à la colonne j et ligne i */
  int getValeur(int i, int j) {
    return this.grille[i][j];
  }

  /* function copier() : Retourne une copie de la grille de l’instance */
  List<List<int>> copier() {
    List<List<int>> NouvGrille =
        List.generate(taille, (i) => List(taille), growable: false);
    ;
    for (int i = 0; i < this.taille; i++) {
      for (int j = 0; j < this.taille; j++) {
        NouvGrille[i][j] = this.grille[i][j];
      }
    }
    return NouvGrille;
  }

  /* function equals(Object y) : Retourne une valeur true si la grille est bien égale à une autre grille y.
		 														 Retourne une valeur false si la grille n'a pas la même taille ou les mêmes valeurs par case que la grille y ou tout simplement si y n'est pas une grille.
																	
	*/
  bool equals(var y, Grille g) {
    if (y == g) {
      Grille deux = y;
      if (deux.getTaille() != this.getTaille()) {
        return false;
      } else {
        for (int i = 0; i < this.taille; i++) {
          for (int j = 0; j < this.taille; j++) {
            if (deux.getValeur(i, j) != this.getValeur(i, j)) {
              return false;
            }
          }
        }
        return true;
      }
    }
    return false;
  }

  /* function toString() : Affichage */
  String toString() {
    String res = "\n";
    for (int i = 0; i < this.taille; i++) {
      for (int j = 0; j < this.taille; j++) {
        res = res + grille[i][j].toString() + "|";
      }
      res = res + "\n";
    }

    return res;
  }
}
