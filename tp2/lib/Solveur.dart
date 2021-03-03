import 'Noeud.dart';
import 'Grille.dart';

class Solveur {
  /* Attribut de la classe Solveur */

  List<Noeud> liste_noeuds_ouverts = [];
  List<Noeud> liste_noeuds_fermes = [];

  /* function algoAstar() : implemente l’algorithme A∗ pour r ́esoudre la grille
	passee en parametre et retourne le noeud correspondant a la grille resolue sinon
	elle retourne null*/

  Noeud algoAstar(Grille initial) {
    /* 1. On  initialise  un  noeud  avec  la  grille  initiale  et  on  le  met  dans  la  liste ouverte liste ouverte.*/
    this.liste_noeuds_ouverts.add(new Noeud(initial, null, 0));

    /*2. On cherche le meilleur noeud de la liste ouverte. Il s’agit du noeud qui a la valeurf=g+h minimale. On le note noeudCourant.*/
    while (this.liste_noeuds_ouverts.isEmpty == false) {
      Noeud noeudCourant = meilleurNoeud(this.liste_noeuds_ouverts);
      if (noeudCourant.estUnEtatFinal() == true) {
        return noeudCourant;
      }
      /* 3. On ajoute noeudCourant a la liste fermee et on le retire de la liste ouverte. */
      this.liste_noeuds_fermes.add(noeudCourant);
      this.liste_noeuds_ouverts.remove(noeudCourant);

      /*4. On genere tous les noeuds successeurs du noeud Courant en deplacant la case vide.*/
      List<Grille> Successeurs = noeudCourant.Successeurs();
      for (Grille s in Successeurs) {
        Noeud n = new Noeud(s, noeudCourant, noeudCourant.gstar() + 1);
        if (existeDansListe(this.liste_noeuds_fermes, s)) {
          continue;
        }
        /* Si s n’est pas dans la liste ouverte, on le rajoute a cette liste. */
        if (existeDansListe(liste_noeuds_ouverts, s) == false)
          this.liste_noeuds_ouverts.add(n);

        /* Sinon, s’il existe dans la liste ouverte un noeud n avec une grille identique `a 
				celle des, alors on remplace n par s dans la liste ouverte si et seulement si l’evaluation du noeuds est meilleure que celle den:s.f()< n.f()*/
        else {
          Noeud i = Element(this.liste_noeuds_ouverts, s);
          if (i.f() > n.f()) {
            this
                .liste_noeuds_ouverts
                .insert(this.liste_noeuds_ouverts.indexOf(i), n);
          }
        }
      }
    }
    return null;
  }

  Noeud Element(List<Noeud> liste, Grille s) {
    for (Noeud noeudtemp in liste) {
      if (s.equals(noeudtemp.getGrille(), s) == true) return noeudtemp;
    }
    return null;
  }

  /* function existeDansListe(ArrayList<Noeud> liste,Grille g) : Permet de savoir si une grille existe dans la liste mit en parametre */

  bool existeDansListe(List<Noeud> liste, Grille g) {
    for (Noeud noeudtemp in liste) {
      if (g.equals(noeudtemp.getGrille(), g) == true) return true;
    }
    return false;
  }

  /* function meilleurNoeud(ArrayList<Noeud> liste) : Retourne le meilleur noeud de la liste mit en parametre */

  Noeud meilleurNoeud(List<Noeud> liste_noeuds) {
    int f = 0;
    Noeud Meilleurnoeud = null;
    for (Noeud noeudtemp in liste_noeuds) {
      if (Meilleurnoeud == null) {
        Meilleurnoeud = noeudtemp;
        f = noeudtemp.f();
      } else {
        if (noeudtemp.f() < f) {
          f = noeudtemp.f();
          Meilleurnoeud = noeudtemp;
        }
      }
    }
    return Meilleurnoeud;
  }

  /* function cheminComplet(Noeud noeudFinal) : Retourne les etapes de la résoution de la grille, j'ai du utiliser la librarie collections pour inverser la liste */
  List<Grille> cheminComplet(Noeud noeudFinal) {
    List<Grille> liste_grilles = [];
    while (noeudFinal.getPere() != null) {
      Grille g = noeudFinal.getGrille();
      noeudFinal = noeudFinal.getPere();
      liste_grilles.add(g);
    }
    //Collections.reverse(liste_grilles.re);
    return liste_grilles;
  }
}
