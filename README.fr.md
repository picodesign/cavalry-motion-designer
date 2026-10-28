# Cavalry Motion Designer

Un skill qui fait d'un agent de code un motion designer senior pour [Cavalry](https://cavalry.studio), l'application d'animation 2D procédurale. Il fonctionne avec le serveur MCP de Cavalry : l'agent lit la scène, la construit en JavaScript et vérifie le résultat à l'écran.

> Projet communautaire non officiel, sans lien avec Canva ni l'équipe Cavalry. Cavalry est une marque de ses propriétaires.

## Ce qu'il apporte

- **Le procédural d'abord.** Behaviours, duplicators, falloffs, connexions et palette partagée avant toute keyframe. Les keyframes servent aux quelques gestes qui en ont besoin.
- **Une direction artistique intégrée.** Timing en images et secondes, easing par intention, rythme de lecture, zones de sécurité (16:9, 9:16, 1:1, 4:5) et checklist qualité avant livraison.
- **Une boucle de travail avec le MCP.** Cadrer, chercher le node, valider le script, l'exécuter, puis vérifier par captures à plusieurs images et mesure des boîtes englobantes.
- **Des recettes testées.** Logo reveal, slogan mot par mot, pastilles réseaux en cascade, end-card de 6 s, pilotés par un null de contrôle pour rester réglables.
- **Des garde-fous.** Pièges de l'API JavaScript (axe Y vers le haut, clés pointées pour les keyframes, règles de connexion, types cachés) et limites à signaler (Lottie, profondeur de champ, particules).

## Installation

Il faut Cavalry avec son serveur MCP connecté à votre agent.

```sh
git clone https://github.com/picodesign/cavalry-motion-designer.git
cd cavalry-motion-designer
./install.sh
```

Le script copie `skills/cavalry-motion-designer` dans `~/.claude/skills/`. Relancez ensuite la session de l'agent. Pour une installation manuelle, copiez ce dossier dans le répertoire de skills de votre agent.

## Utilisation

Décrivez le mouvement voulu avec vos mots, par exemple :

- « Construis une end-card de 6 secondes avec le logo, un slogan et trois pastilles réseaux, en 1920×1080 à 30 i/s. »
- « Anime ce titre mot par mot, avec un léger overshoot. »
- « Rends cette boucle parfaitement continue. »

Le skill s'active sur les mentions de Cavalry, logo reveal, end-card, animation de texte, duplicator, behaviours, easing, boucle ou export.

## Limites

- Les attributs cochés dans `nodes-catalogue.md` ont été vérifiés dans Cavalry ; les autres ne sont confirmés que par leur type de node. Vérifiez-les avec `get_layer_definition`.
- Les formats d'export et les licences (ProRes, Lottie) ne sont pas tranchés : testez l'export avant de le promettre.
- Le forum, Discord et Reddit n'étaient pas accessibles lors de la recherche. Les astuces viennent de la doc officielle, d'articles et d'issues publiques.

## Contribuer

Corrections, recettes et attributs vérifiés sont bienvenus. Voir [CONTRIBUTING.md](CONTRIBUTING.md).

## Licence

[MIT](LICENSE)
