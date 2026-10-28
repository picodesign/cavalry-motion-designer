# Principes de motion design (regard d'un directeur motion senior)

Ce fichier dit CE QU'IL FAUT VOULOIR VOIR à l'écran, puis COMMENT l'obtenir dans Cavalry sans bricoler. Règle d'or de l'ensemble du skill : **procédural d'abord, keyframes en dernier recours** (voir la section « Procédural vs keyframes » plus bas). Le workflow, les scripts complets et l'export sont dans `deliverables-workflows.md`.

Vérifié contre l'API réelle : `magicEasing`, `stagger`, `shapeTimeOffset`, `autoAnimate`, nœud `value` (avec `timeOffset`), `oscillator`, Scene Palette, `applyTextMaterial`. Rappel de coordonnées : origine au centre du comp, **Y vers le haut**.

---

## 1. Temps : secondes d'abord, images ensuite

On pense en secondes (durée perçue), on convertit en images selon la cadence du projet. Ne jamais figer un nombre d'images « en dur » : calculer depuis `fps`.

| Action (durée perçue) | 24 i/s | 25 i/s | 30 i/s | 60 i/s |
|---|---|---|---|---|
| Micro-interaction (pastille, toggle) 0,25 s | 6 | 6 | 8 | 15 |
| Apparition d'un élément UI / texte 0,5 s | 12 | 12 | 15 | 30 |
| Geste de logo / mouvement principal 0,7 à 1 s | 17 à 24 | 18 à 25 | 21 à 30 | 42 à 60 |
| Transition de scène 1 à 1,5 s | 24 à 36 | 25 à 38 | 30 à 45 | 60 à 90 |
| Stagger entre 2 éléments 0,08 à 0,16 s | 2 à 4 | 2 à 4 | 2 à 5 | 5 à 10 |
| Dérive ambiante lente 3 s et plus | 72+ | 75+ | 90+ | 180+ |

Conversions utiles : `frames = secondes * fps` ; timecode `api.framesToTimecode(frames, fps)` et `api.timecodeToFrames(tc, fps)`.

Choix de cadence : 25 i/s = TV/web Europe, 24 i/s = cinéma/film, 30 i/s = web/réseaux (US), 60 i/s = UI/écrans fluides, jeux. En cas de doute pour des réseaux sociaux : 30. Ne JAMAIS changer de cadence en cours de projet sans re-timer : une animation conçue à 25 i/s lue à 30 i/s est 20 % trop rapide.

Plancher perceptif : moins de 6 images à 24 i/s (≈ 0,25 s) se lit comme un « snap » et non une transition. Plafond : plus de ~40 images pour un mouvement actif paraît mou, sauf intention contemplative.

Dans Cavalry : `api.set(comp, { fps: 25, endFrame: 149, playbackEnd: 149 })`. Pour une boucle de N images, `endFrame = N - 1`.

---

## 2. Les 12 principes appliqués au motion graphics, traduits en actions Cavalry

### 2.1 Écrasement et étirement (squash & stretch)
Un logo ou une pastille qui arrive avec une légère déformation paraît vivant. Garder 3 à 8 % de déformation, jamais plus en institutionnel.
- Cavalry : animer `scale.x` et `scale.y` en opposition de phase légère, ou `OvershootOut` sur l'échelle (réponse élastique sans keyframes supplémentaires). Pivot centré : `api.centrePivot(id, true)`.

### 2.2 Anticipation
Petit contre-mouvement de 2 à 4 images avant le geste principal. Sert à « annoncer » une entrée importante (logo, CTA).
- Cavalry : `AnticipateIn` ou `AnticipateInOvershootOut` en magic easing sur le geste-source. À réserver aux éléments héros, pas aux 30 pastilles.

### 2.3 Mise en scène (staging)
Un seul message prioritaire par plan. Ce qui bouge attire l'œil : ne rien animer d'autre pendant que le héros arrive. Donc : pas de dérive ambiante qui se superpose à l'entrée du logo, plutôt un `oscillator` à faible amplitude qui démarre après.

### 2.4 Pose à pose vs mouvement continu (straight ahead / pose to pose)
En motion graphics : on pose des poses clés (début / fin) et on laisse l'easing interpoler (pose à pose). Le mouvement continu (bruit, oscillation) se fait avec des behaviours, jamais image par image.
- Cavalry : deux poses = 2 keyframes sur UN nœud source ; continu = `noise` / `oscillator` / `frame`.

### 2.5 Continuité et chevauchement (follow-through / overlapping)
Les éléments secondaires s'arrêtent après l'élément principal : le filet sous le logo se termine 4 à 8 images après l'anneau ; le sous-titre arrive pendant que le titre se pose.
- Cavalry (procédural) : un nœud `value` par bloc, relié à la source, avec `timeOffset` négatif = retard (-14 = démarre 14 images plus tard). Un seul geste keyframé, N retards réglables.

```js
const d = api.create("value", "P_Delai_Mot");
api.connect(src, "id", d, "value");   // src = value keyframé 0 -> 100
api.set(d, { timeOffset: -14 });      // retard réglable, aucun keyframe à toucher
```

### 2.6 Ralentis en entrée / en sortie (slow in / slow out)
Presque tout accélère puis ralentit. Une courbe linéaire (`None`) est quasi toujours une erreur.
- Cavalry : `SlowInSlowOut` par défaut, `SlowOut` pour les entrées (démarrage vif, atterrissage doux), `SlowIn` pour les sorties. `api.magicEasing(id, attr, frameDuDébut, nom)`. L'easing se pose sur la keyframe de DÉPART, la dernière keyframe n'en a pas.

### 2.7 Arcs
Un mouvement naturel suit un arc. Pour un déplacement 2D de plus de 200 px, ajouter une légère composante perpendiculaire.
- Cavalry : `autoAnimate` en `positionMode: 2` (Drift) avec `angleDistance` oblique (ex. `[90, 60]`) plutôt qu'un glissement purement horizontal ; ou `pathfinder` sur un chemin courbe.

### 2.8 Action secondaire
Une respiration lente du logo, un halo qui dérive, un grain : donne de la vie sans voler la lecture.
- Cavalry : `oscillator` (amplitude 1 à 2 %, `frequency` en cycles/seconde ; 0,25 = un cycle en 4 s). Réglé sur un nombre entier de cycles pour que ça boucle. Penser `strengthToZero: false` quand la valeur de repos n'est pas 0 (échelle = 1).

### 2.9 Timing
Le timing donne le poids et l'intention. Rapide + dur = énergique ; lent + doux = luxe, calme. Calibrer sur la marque (voir section 9). Un changement de 2 images change l'émotion : c'est pourquoi les retards doivent être des paramètres (nœuds `value`) et non des keyframes perdues dans la timeline.

### 2.10 Exagération
Pousser juste assez pour que ça se lise sur un téléphone en plein soleil. Dépassement (`OvershootOut`) à 10 à 15 %, pas 40.

### 2.11 Dessin solide (solid drawing) -> composition solide
En 2D : alignements, grille, marges, hiérarchie de tailles. Voir sections 5 et 6.

### 2.12 Attrait (appeal)
Formes simples, rythme clair, finition propre : pivot centré, rayons de coins cohérents (`generator.cornerRadius`), pas de crénelage, pas de texte qui tremble. L'attrait vient de la cohérence : mêmes courbes, mêmes durées, mêmes retards partout.

---

## 3. Courbes d'easing par intention

| Intention | Courbe Cavalry (`magicEasing`) | Notes |
|---|---|---|
| Entrée standard (UI, texte, pastille) | `SlowOut` | Démarre vif, se pose doucement. Défaut des arrivées. |
| Mouvement naturel général | `SlowInSlowOut` | Défaut quand on hésite. |
| Sortie, disparition | `SlowIn` | Accélère en partant. |
| Moment fort, logo | `VerySlowInVerySlowOut` / `VerySlowOut` | Plus délibéré, premium. |
| Arrivée confiante qui dépasse la cible | `OvershootOut` | 10 à 15 %. Boutons, badges, logos. |
| Contre-geste avant l'action | `AnticipateIn` | Héros uniquement. |
| Charge puis relâche | `AnticipateInOvershootOut` | CTA, pastille « pop ». |
| Atterrissage élastique | `SpringOut` / `SmallSpringOut` | `SmallSpring*` pour de la vie sans rebond comique. |
| Chute pesante | `BounceOut` | Rare. Une carte qui tombe sur une table. |
| Linéaire | `None` | Seulement pour du défilement constant (générique, ticker) ou de la rotation continue. |

Pièges : mettre le même easing symétrique partout (mouvement robotique) ; poser l'easing sur la keyframe de destination ; compter sur l'easing pour sauver un mouvement de 4 images ; utiliser le nœud `spring` pour un scalaire (il sort un polyMesh, utiliser l'easing `SpringOut`).

Courbe sur mesure (rare) : `api.modifyKeyframeTangent(id, { progress: { frame: 0, outHandle: true, xValue, yValue } })`. Les poignées sont en coordonnées absolues.

Règle de réalisation : un seul geste-source par séquence porte l'easing. Tous les éléments qui en dérivent (retards, échelles, trims) héritent de la courbe. Changer la courbe à un endroit change tout le projet.

---

## 4. Hiérarchie de lecture et rythme

### 4.1 Ordre de lecture
1. Marque / héros (logo, packshot) ;
2. Message (slogan) ;
3. Action (CTA, URL, handle).
Chaque niveau arrive 6 à 12 images après le précédent, jamais tous ensemble. Taille de police : ratio d'au moins 1,5 entre niveaux (ex. 96 / 52 / 36 sur 1080p).

### 4.2 Temps de lecture du texte
Règle pratique : **durée d'affichage lisible (hold, une fois le texte entièrement en place) = 0,3 s par mot + 0,6 s**, minimum 1,2 s pour tout texte.
- 3 mots : environ 1,5 s de hold ;
- 6 mots : environ 2,4 s ;
- 10 mots : environ 3,6 s ;
- URL / handle : minimum 2 s (l'œil doit le copier).
Pour du contenu qui sera lu sur mobile (9:16) ajouter 20 % : l'attention est partagée.

L'animation d'entrée n'est PAS comptée dans le temps de lecture. Un slogan de 6 mots avec entrée par mot de 0,8 s et sortie de 0,5 s occupe donc environ 3,7 s.

### 4.3 Durée de hold des plans
- Logo en fin de spot : 1,5 à 2,5 s de hold complet ;
- Packshot / end-card : 3 à 4 s de hold lisible (total 5 à 6 s) ;
- Lower third : 3 à 5 s ;
- Pastilles réseaux : cascade 1 s puis hold 2 s minimum.
Le hold n'est pas « immobile » : une respiration `oscillator` très légère évite l'effet de photo figée, sans distraire.

### 4.4 Rythme
Alterner temps forts et temps faibles. Éviter les 6 éléments qui arrivent sur le même battement : chaque 3e élément peut reprendre la même cadence (par exemple pas de 0,12 s) ; la régularité crée le rythme, la variation crée la surprise. Procédural : un `stagger` (minimum / maximum) ou `timeOffset` d'`autoAnimate`, pas des keyframes décalés à la main.

---

## 5. Stagger, overlap, follow-through : les outils exacts

| Besoin | Outil Cavalry | Réglage |
|---|---|---|
| N copies qui arrivent en cascade | `duplicator` + `stagger` -> `shapeTimeOffset` | `stagger.minimum = 0`, `stagger.maximum = délai total en images`. Le template est keyframé une seule fois. |
| Cascade sans keyframe du tout | `autoAnimate` (`useLevels: true`, `levelMode: 1` pour les copies d'un duplicator) sur `duplicator.deformers` | `progress` relié à un nœud `value`. `timeOffset` = durée totale du stagger en images (par défaut -20). |
| Mots / caractères de texte | `autoAnimate` sur `textShape.deformers`, `levelMode: 2` (mots) ou `3` (caractères) | `timingMode: 0` séquentiel, `1` aléatoire, `2` depuis le milieu. `reverseTimeOffset` si on part de la gauche et que ça fait « accordéon ». |
| Retard d'un bloc par rapport à un autre | nœud `value` avec `timeOffset` négatif relié à la source | Paramètre unique, éditable sans toucher de keyframe. |
| Stagger non linéaire | `stagger.graph` (courbe composée) | Voir hint `compound-graphs`. |
| Tous les éléments décalés de façon organique | `random` sur `shapeTimeOffset` | `useIndex: true` pour stabilité. |

`autoAnimate.progress` : 0 = en vol (hors scène, transparent) ; 100 = au repos. Il embarque par défaut deux keyframes (0 -> 0, 24 -> 100) qu'il faut supprimer si on veut le piloter par connexion :

```js
for (const f of api.getKeyframeTimes(aa, "progress")) api.deleteKeyframe(aa, "progress", f);
api.connect(sourceValue, "id", aa, "progress");
```

Follow-through (mouvement résiduel) : un nœud `value` supplémentaire avec un `timeOffset` plus long sur l'élément secondaire (filet, sous-titre) ; il s'arrête plus tard par construction.

---

## 6. Composition et zones de sécurité

| Format | Résolution de référence | Usage | Marges / zones à respecter |
|---|---|---|---|
| 16:9 | 1920x1080 (3840x2160 en 4K) | TV, YouTube, web | Action safe 93 % (marge 3,5 %), titre safe 90 % (marge 5 % : 96 px en 1080p). Pas de texte à moins de 96 px des bords. |
| 9:16 | 1080x1920 | Stories, Reels, TikTok, Shorts | Réserver environ 250 px en haut (profil / statut) et 340 à 420 px en bas (légende, boutons). Marges latérales 64 px. Le texte important vit entre y = +600 et y = -500 (Y vers le haut, centre 0). |
| 1:1 | 1080x1080 | Fil Instagram, LinkedIn | Marge 80 px. Message au centre, rien dans les 10 % extérieurs (recadrage de grille). |
| 4:5 | 1080x1350 | Fil Instagram portrait | Marge 72 px. Haut et bas peuvent être rognés en aperçu de grille (3:4) : garder le texte vital dans les 80 % centraux. |

Conversion en coordonnées Cavalry (comp 1920x1080) : bord haut y = +540, bas y = -540, gauche x = -960, droite x = +960. Titre-safe : x dans [-864, +864], y dans [-486, +486].

Pour un livrable multi-format : construire le master dans un comp « Master » avec tous les éléments sous un null CTRL ; décliner chaque format dans un comp séparé en réutilisant le master (précomp via `api.createCompReference(compId)`), en repositionnant seulement les groupes de mise en page. Ne jamais redessiner : réutiliser.

Alignement : choisir une grille (colonnes de 120 px par exemple), aligner sur la ligne de base ou le bord gauche, centrer verticalement avec `verticalAlignment: 1`. Pour centrer un texte sur l'origine : `horizontalAlignment: 1`, `verticalAlignment: 1`, `autoWidth: true`, `autoHeight: true`, `textBoxSize: [1, 1]`, `position: [0, 0]`. Contrôler ensuite avec `api.getBoundingBox(id, true)` ({left, right, top, bottom, centre}).

---

## 7. Typographie animée

- Animer au niveau du mot pour de la lisibilité, au niveau du caractère pour un titre court (moins de 12 caractères). Au-delà, l'oeil n'a pas le temps.
- Entrée : `autoAnimate` avec `positionMode: 2` (Drift) + `opacityMode: 1` (Fade Up), distance 40 à 90 px, `timingMode: 0`. Éviter `Slide From Composition Edge` pour des animations de moins de 2 s : trop de distance.
- Ne pas animer l'échelle d'un paragraphe : le texte devient flou / tremble. Préférer position + opacité.
- Typewriter : `stringManipulator` + `resizeString` (`indexMode: 0` caractères, `percentage` 0 -> 100), alignement GAUCHE pour que la mise en page ne glisse pas pendant la frappe.
- Mots en accent : `applyTextMaterial` avec `mode: 0` (regex), `indexMode: 1` (mot), `regex: "compte|respire"`. Non destructif : on change la regex, pas le texte.
- Interlettrage : `letterSpacing` +8 à +16 pour les capitales (titres de marque), 0 à -2 pour le texte courant.
- Taille minimale lisible : 36 px en 1080p pour du texte secondaire, 28 px en absolu ; 44 px minimum en 9:16 (lu sur petit écran).
- Contraste : voir section 8. Lignes de 2 à 7 mots maximum, retour à la ligne volontaire (`\n`), `avoidOrphans`.
- Police : charger via `font: { font: "Lato", style: "Bold" }` ; pour lister les familles `cavalry.getFontFamilies()`. Mesure exacte : `cavalry.measureText(texte, famille, style, taille)`.
- Le texte exporté en Lottie devient des formes (non éditable) : à signaler.

---

## 8. Couleur et contraste

- Utiliser la **Scene Palette** pour toute couleur partagée par au moins deux calques : `api.addSceneSwatch("#ff5a36", "Accent")` renvoie l'index ; on connecte `api.connect(api.getScenePalette(), "array." + index, id, "material.materialColor")` (remplissage) ou `"stroke.strokeColor"` (contour). Changer la teinte du swatch met à jour tout le projet.
- Ratio de contraste texte/fond : 4,5:1 minimum pour le texte courant, 3:1 pour du texte très gros (> 56 px). Vérifier avec `snapshot_layer` à 100 % et en niveaux de gris mentalement : si le texte disparaît en niveaux de gris, le contraste est insuffisant.
- Palette de scène : 1 fond, 1 surface, 1 texte, 1 accent, éventuellement 1 accent secondaire. Maximum 4 à 5 couleurs actives à l'écran.
- Accent : réservé à ce qui doit être regardé (mot clé, CTA, trait). Si tout est accent, rien ne l'est.
- Dégradés : `multiPointGradientShader` pour des halos / ambiances ; un halo flou = ellipse avec `featherAmount` élevé + `opacity` 30 à 40.
- Fond sombre : éviter le noir pur (#000), préférer un noir teinté (#0e1116) ; le blanc pur éblouit : #f4efe6 ou équivalent chaud.
- Gestion de couleur : la sortie vidéo H.264 est en espace colorimétrique écran standard ; vérifier la section Color Management de Cavalry si la marque exige un profil précis.
- Daltonisme : ne jamais coder une information uniquement par la couleur (ajouter forme / libellé).

---

## 9. Cohérence de marque

Avant d'animer, extraire de la marque : couleurs (hex), polices, ton (calme / énergique / premium / ludique), formes récurrentes (angles / arrondis), et un « verbe de mouvement » : *glisser*, *poser*, *respirer*, *claquer*.
Traduire en paramètres globaux, stockés dans le null CTRL ou les nœuds `value` :

| Ton de marque | Easing dominant | Durée du geste | Pas de stagger | Dépassement |
|---|---|---|---|---|
| Premium, éditorial | `VerySlowInVerySlowOut`, `SlowOut` | 0,8 à 1,2 s | 0,12 à 0,2 s | 0 % |
| Corporate, neutre | `SlowInSlowOut` | 0,5 à 0,8 s | 0,08 à 0,12 s | 0 à 5 % |
| Jeune, pop | `OvershootOut`, `SmallSpringOut` | 0,4 à 0,6 s | 0,06 à 0,1 s | 10 à 15 % |
| Tech, précis | `SlowOut`, `None` pour les défilements | 0,3 à 0,5 s | 0,04 à 0,08 s | 0 % |

Une fois le « vocabulaire » choisi, le garder partout : même courbe, mêmes durées, mêmes retards. Un directeur motion repère immédiatement deux animations qui n'ont pas été pensées ensemble.

Nommage : `CTRL_`, `P_` (paramètres), `Anim_`, éléments en français clair (Anneau, Wordmark). Un autre motion designer doit retrouver où régler quoi.

---

## 10. Éléments types : ce qu'il faut viser

### Logo reveal (3 à 4 s, 25 i/s : 75 à 100 images)
Structure : signe (dessin du contour ou échelle) 0 à 1 s ; nom / wordmark 0,5 à 1,5 s ; filet ou baseline 1 à 1,8 s ; hold 1,5 s ; respiration discrète. Un seul geste-source, des retards via `value.timeOffset`. Voir recette 1 dans `deliverables-workflows.md`.

### Packshot / end-card (5 à 6 s)
Ordre : fond et halo -> produit (échelle + fondu, 0,25 s de retard) -> marque -> accroche -> CTA -> URL. Hold lisible de 3 s minimum ; sortie 0,5 s (opacité) pour enchaîner. Produit au tiers gauche ou droit (règle des tiers), texte du côté opposé, aligné à gauche. Safe zones respectées. Recette 4.

### Lower third (4 à 5 s)
Entrée 0,5 s (barre qui s'étire puis texte en retard de 0,2 s), hold 3 s, sortie 0,4 s (inverse de l'entrée, plus rapide). Placé dans le tiers inférieur, titre-safe respectée : x à ±864 max, y entre -486 et -250. Nom en 44 à 56 px, fonction en 30 à 36 px. Les deux lignes arrivent avec un décalage de 4 images (`timeOffset`).

### Transition
Durée 0,5 à 1 s, courbe asymétrique (`SlowInSlowOut`). Un élément du plan sortant est repris dans le plan entrant (match cut, forme qui grossit et devient le fond suivant). Alternatives procédurales : `autoAnimate` en `positionMode: 1` (Slide From Composition Edge) sur un groupe de bandes dupliquées, ou masque animé via trim.

### Pastilles réseaux sociaux
Cascade de 4 à 6 pastilles, stagger 0,1 à 0,15 s, `SlowOut`, chaque pastille de largeur fixe (mêmes rayons), libellé contrasté, hold 2 s. Procédural : duplicator + `stringArray` pour les libellés. Recette 3.

### Slogan par mot
Entrée mot par mot (`levelMode: 2`), 0,06 à 0,12 s entre les mots, mots clés en accent par regex, hold calculé selon la règle de lecture, sortie symétrique par la même valeur source passant de 100 à 0. Recette 2.

---

## 11. Procédural vs keyframes : arbre de décision

Le réflexe courant est de poser des keyframes et des valeurs en dur dès qu'on parle d'animation. Corriger systématiquement ce réflexe en suivant cet arbre.

1. **Le mouvement doit-il durer / se répéter / respirer indéfiniment ?** Oui -> behaviour : `frame` (temps linéaire), `oscillator` (va-et-vient, respiration), `noise` (organique), `random` (variation stable avec `useIndex: true`). Pas de keyframes.
2. **Y a-t-il N éléments semblables (pastilles, lettres, mots, barres, points) ?** Oui -> `duplicator` + distribution (`linearDistribution`, `gridDistribution`, `circleDistribution`...) + `stagger` -> `shapeTimeOffset` ou `autoAnimate` (`levelMode: 1`). Jamais une boucle `api.create` de N calques.
3. **Est-ce du texte ?** Oui -> `autoAnimate` sur `deformers` (mots / lignes / caractères), `resizeString` pour le typewriter, `transitionString` pour le morph, `applyTextMaterial` / `applyFontSize` pour le style par plage, `stringGenerator` pour des valeurs procédurales. Jamais un `textShape` par mot.
4. **L'élément B suit l'élément A avec un retard ou une proportion ?** Oui -> connexion : nœud `value` relié à la source avec `timeOffset` (retard) ou `strength` (proportion). Ou expression d'attribut : `api.setAttributeExpression(id, "rotation.z", "+15")` (ne fonctionne que si l'attribut a déjà une connexion entrante).
5. **Une couleur est-elle partagée par 2 calques ou plus ?** Oui -> Scene Palette (`addSceneSwatch` + `connect`).
6. **Reste-t-il UN geste artistique à la main (la courbe d'entrée du héros, l'arrivée du logo) ?** Oui -> 1 nœud `value` source avec 2 à 4 keyframes et `magicEasing`. C'est la seule place où l'on pose des keyframes. Tout le reste dérive de ce nœud (connexions, retards, échelles).
7. **Une valeur doit-elle être réglée par le client / l'équipe (durée, délai, couleur, texte) ?** Oui -> la mettre sur un nœud nommé `P_...` / dans la Scene Palette / sur un `stringArray`, pas dans un script ni dans une keyframe.

Nombre cible : au maximum 1 nœud source keyframé par séquence (2 si une sortie distincte est nécessaire), 0 keyframe sur les calques visibles.

Piège : `api.set` sur un attribut déjà keyframé écrit une keyframe à l'image courante. Ne pas « sonder » un attribut animé par `set`.
Piège : `resetAttribute` ne supprime pas les keyframes (`getKeyframeTimes` puis `deleteKeyframe`).
Piège : `api.get` renvoie `null` pour tout attribut connecté : vérifier par l'effet (`snapshot_layer`, `getBoundingBox`) ou `api.getInConnection(id, attr)`.

### Checklist « réglable sans retoucher de keyframe »
Avant de livrer, vérifier que, sans ouvrir la timeline :
- [ ] Je peux **changer la durée de l'entrée** en modifiant un seul nœud (la source) ou `timeOffset` d'un `autoAnimate`.
- [ ] Je peux **décaler un bloc** (retard) en changeant un `timeOffset` sur un nœud `P_Delai_*`.
- [ ] Je peux **changer la couleur de marque** en éditant un swatch de la Scene Palette, et tout suit.
- [ ] Je peux **changer le texte** (slogan, libellés des pastilles) sans casser l'animation : le texte est dans `text` ou `stringArray`, les mots-clés par regex.
- [ ] Je peux **ajouter / retirer une pastille** en changeant `generator.count` du duplicator et en ajoutant une entrée au `stringArray`.
- [ ] Je peux **changer la cadence ou la durée du comp** sans que rien ne casse (aucune keyframe hors plage, aucun nombre d'images codé en dur).
- [ ] Je peux **réutiliser** le groupe dans un autre format en le plaçant dans un autre comp (précomp).
- [ ] Les keyframes qui restent sont sur **un seul nœud nommé** `P_...`, avec `magicEasing` sur chaque transition.
- [ ] Aucune boucle `api.create` ne génère N copies à la main.
- [ ] Les calques et nœuds ont des noms lisibles ; les paramètres sont regroupés sous `CTRL_*`.

---

## 12. Checklist de revue qualité avant livraison

Passer en revue comme un directeur motion, sur le rendu et pas seulement dans l'interface.

**Lecture**
- [ ] Le message principal se lit en moins de 2 s ; la hiérarchie héros / message / action est évidente.
- [ ] Temps de lecture respecté (0,3 s par mot + 0,6 s, minimum 1,2 s).
- [ ] Un seul élément prioritaire bouge à la fois pendant les moments clés.
- [ ] Pas de texte à moins de 5 % du bord ; zones de sécurité du format respectées.

**Mouvement**
- [ ] Aucun mouvement linéaire (sauf défilement constant volontaire) ; chaque transition porte un easing posé sur la keyframe de départ.
- [ ] Easing asymétrique, entrées `SlowOut`, sorties `SlowIn`.
- [ ] Stagger présent (2 à 4 images à 24/25 i/s) entre éléments simultanés.
- [ ] Éléments secondaires terminent après les principaux (follow-through).
- [ ] Aucun mouvement inférieur à 6 images (à 24/25 i/s) ; aucun mouvement actif supérieur à ~40 images sans intention.
- [ ] Pivots centrés (`centrePivot`) sur tout ce qui tourne ou change d'échelle.
- [ ] Hold final suffisant ; pas de coupe sèche sur un élément en mouvement.
- [ ] Boucle propre si demandée : `endFrame = N - 1`, nombre entier de cycles, vérifier frame 0 vs frame N.

**Image**
- [ ] Contraste suffisant (4,5:1 texte courant) ; couleurs issues de la Scene Palette uniquement.
- [ ] Alignements nets, rayons de coins identiques, aucune forme décalée d'un pixel.
- [ ] Pas de texte flou (pas d'échelle sur paragraphe), pas de crénelage visible sur les contours.
- [ ] Vérifier avec `snapshot_layer` à 4 ou 5 images différentes : début, milieu d'entrée, fin d'entrée, hold, sortie. Contrôler les positions avec `getBoundingBox` échantillonné (`api.setFrame`).

**Technique**
- [ ] Cadence et résolution corrects ; durée = durée demandée +/- 0 image.
- [ ] Aucun calque hors cadre involontaire ; aucun calque orphelin / test dans la scène (scene hygiene).
- [ ] Rendu d'essai à résolution réduite (`Resolution Scale` 0,5) visionné en entier avant le rendu final.
- [ ] Export conforme au support (voir `deliverables-workflows.md`) ; transparence : Background Alpha à 0.

---

## 13. Erreurs d'amateur à éviter

1. **Tout bouge en même temps**, au même moment, à la même vitesse. Remède : stagger, retards, hiérarchie.
2. **Linéaire** par défaut. Remède : easing systématique.
3. **Easing symétrique partout.** Remède : `SlowOut` à l'entrée, `SlowIn` à la sortie.
4. **Dépassements exagérés** (40 %) sur du contenu sérieux. Remède : 10 à 15 % maximum.
5. **Trop long ou trop court** : entrées de 4 images (illisibles) ou de 2 s (soporifiques). Remède : tableau de la section 1.
6. **Texte trop petit ou trop proche des bords**, illisible sur mobile. Remède : tailles minimales et zones de sécurité.
7. **Hold insuffisant** : le texte disparaît avant la fin de la lecture. Remède : formule de la section 4.2.
8. **Texte animé en échelle** sur plusieurs lignes : flou, tremblement. Remède : position + opacité.
9. **Trop de couleurs**, accent partout. Remède : Scene Palette de 4 à 5 couleurs.
10. **Keyframes dispersées** sur 20 calques : impossible à régler. Remède : une source, des connexions.
11. **Valeurs en dur dans le script** (délais, couleurs, textes). Remède : nœuds `P_*`, palette, tableaux de chaînes.
12. **Boucle `api.create` de N copies** au lieu d'un duplicator. Remède : section 11.
13. **Pivot au mauvais endroit** : la rotation ou l'échelle part d'un coin. Remède : `api.centrePivot(id, true)`.
14. **Oublier Y vers le haut** : le titre « en haut » est en bas. Remède : y positif = haut ; vérifier par `getBoundingBox`.
15. **Mouvement ambiant qui entre en concurrence** avec le message. Remède : amplitude faible, démarrage après l'entrée.
16. **Aucune sortie** : le plan se coupe net. Remède : une valeur de sortie reliée à l'opacité du groupe.
17. **Trop d'effets** (filtres, flou, particules) alors que le motif est simple, avec risque de non-export (Lottie). Remède : la sobriété coûte moins cher et se voit moins.
18. **Ne pas regarder le rendu** : juger sur la timeline. Remède : snapshots à plusieurs images, rendu d'essai complet.
19. **Changer de cadence sans re-timer** ; **exporter la mauvaise résolution** ; **oublier l'alpha**.
20. **Scène sale** après un script qui a échoué à mi-chemin : calques en double. Remède : suivre les identifiants créés, nettoyer avant de relancer.
