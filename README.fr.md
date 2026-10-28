# Cavalry Motion Designer

![statut : beta](https://img.shields.io/badge/statut-beta-orange) ![licence : MIT](https://img.shields.io/badge/licence-MIT-blue)

> **Beta.** Ce skill est en développement actif. Attendez-vous à des aspérités, des attributs non vérifiés et des changements entre versions. Retours et rapports de test bienvenus.

Un skill qui fait d'un agent de code un motion designer senior pour [Cavalry](https://cavalry.studio), l'application d'animation 2D procédurale. Il fonctionne avec le serveur MCP de Cavalry : l'agent lit la scène, la construit en JavaScript et vérifie le résultat à l'écran.

> Projet communautaire non officiel, sans lien avec Canva ni l'équipe Cavalry. Cavalry est une marque de ses propriétaires.

## Ce qu'il apporte

- **Le procédural d'abord.** Behaviours, duplicators, falloffs, connexions et palette partagée avant toute keyframe. Les keyframes servent aux quelques gestes qui en ont besoin.
- **Une direction artistique intégrée.** Timing en images et secondes, easing par intention, rythme de lecture, zones de sécurité (16:9, 9:16, 1:1, 4:5) et checklist qualité avant livraison.
- **Une boucle de travail avec le MCP.** Cadrer, chercher le node, valider le script, l'exécuter, puis vérifier par captures à plusieurs images et mesure des boîtes englobantes.
- **Des recettes testées.** Logo reveal, slogan mot par mot, pastilles réseaux en cascade, end-card de 6 s, pilotés par un null de contrôle pour rester réglables.
- **Des garde-fous.** Pièges de l'API JavaScript (axe Y vers le haut, clés pointées pour les keyframes, règles de connexion, types cachés) et limites à signaler (Lottie, profondeur de champ, particules).

## Installation

Deux étapes : connecter Cavalry à votre agent (une seule fois), puis installer le skill.

### 1. Prérequis

- **Cavalry 2.8 ou plus récent**, ouvert. Le skill a besoin de l'application pour lire et construire la scène.
- **Le serveur MCP de Cavalry**, connecté à votre agent. Sans lui, le skill ne fait rien.
- **Un agent qui gère les skills** (un dossier avec un fichier `SKILL.md`).

### 2. Connecter le serveur MCP de Cavalry

Le guide officiel : <https://cavalry.studio/docs/tips/ai-automation-with-claude/>. En résumé, pour Claude Desktop :

1. Téléchargez `cavalry-mcp-server.zip` depuis cette page et décompressez-le.
2. Dans Claude, ouvrez **Settings > Desktop app > Extensions > Advanced settings > Open extensions folder**.
3. Glissez le dossier `cavalry-mcp-server` dedans, puis quittez et relancez Claude.
4. Dans **Extensions**, cliquez **Configure** sur « Cavalry by Canva » et activez-le.
5. Dans Cavalry, ouvrez **Preferences** et cochez **Enable MCP Server**.

Gardez Cavalry et votre agent ouverts en même temps. La page officielle ne documente que Claude Desktop. Pour un autre agent, déclarez le même serveur dans sa configuration MCP.

### 3. Installer le skill

macOS et Linux :

```sh
git clone https://github.com/picodesign/cavalry-motion-designer.git
cd cavalry-motion-designer
./install.sh
```

Windows (PowerShell) :

```powershell
git clone https://github.com/picodesign/cavalry-motion-designer.git
cd cavalry-motion-designer
.\install.ps1
```

Les deux scripts copient `skills/cavalry-motion-designer` dans votre dossier de skills (`~/.claude/skills` sur macOS et Linux, `%USERPROFILE%\.claude\skills` sur Windows). Relancez ensuite la session de l'agent.

**Pour un seul projet**, indiquez un dossier cible :

```sh
./install.sh /chemin/vers/votre/projet/.claude/skills
```

**Sans git**, téléchargez le dépôt en ZIP, décompressez-le et copiez `skills/cavalry-motion-designer` dans le dossier de skills de votre agent.

### 4. Vérifier que ça marche

Avec Cavalry ouvert, demandez à votre agent :

> Vois-tu le serveur MCP de Cavalry ? Liste ensuite les layers de ma scène ouverte.

S'il répond avec les layers, la connexion fonctionne. Demandez ensuite quelque chose de simple pour vérifier que le skill est chargé :

> Crée un titre de 2 secondes qui apparaît en fondu avec un easing, avec un délai réglable.

Une installation correcte construit le titre avec un null de contrôle et une animation avec easing, puis vérifie le résultat par une capture.

### Mise à jour et désinstallation

- **Mise à jour :** `git pull`, puis relancez le script d'installation. Il remplace la copie installée.
- **Désinstallation :** supprimez le dossier `cavalry-motion-designer` de votre dossier de skills.

### Dépannage

- **L'agent ne voit pas Cavalry :** vérifiez que Cavalry 2.8 ou plus est ouvert et que **Enable MCP Server** est coché, puis relancez les deux applications.
- **Le skill ne se déclenche jamais :** relancez la session et vérifiez que `cavalry-motion-designer/SKILL.md` est directement dans le dossier de skills.
- **Un script échoue en cours de route :** Cavalry n'annule pas un script en échec. Utilisez l'annulation de Cavalry, ou demandez à l'agent de supprimer ce qu'il a créé avant de réessayer.

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
