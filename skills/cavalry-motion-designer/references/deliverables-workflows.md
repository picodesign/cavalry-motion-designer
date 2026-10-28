# Livrables et workflows : de la demande au rendu

Complète `motion-principles.md` (regard artistique, timing, checklist). Ici : comment cadrer, structurer la scène, travailler avec le MCP Cavalry, exporter, et quatre recettes complètes **procédurales** (logo reveal, slogan par mot, pastilles en cascade, end-card packshot).

Principe directeur : **procédural et non destructif**. Un seul nœud source keyframé par séquence (avec `magicEasing`), tout le reste en connexions : nœuds `value` avec `timeOffset`, `autoAnimate`, `duplicator` + `stagger`, `oscillator` / `noise` / `frame`, Scene Palette, `stringArray`. Les scripts ci-dessous ont été exécutés et contrôlés par `snapshot_layer` sur Cavalry (comp 1920x1080, 25 i/s).

Rappel : **origine au centre, Y vers le haut**. Comp 1920x1080 : bord haut y = +540, gauche x = -960.

---

## 1. Questions de cadrage à poser (avant tout script)

Poser ces questions d'un bloc, avec une proposition par défaut pour chacune, puis avancer.

1. **Objectif et diffusion** : où sera-t-il vu (TV, YouTube, réseaux, site, appli, écran en magasin) ?
2. **Format(s)** : 16:9 (1920x1080 / 3840x2160), 9:16 (1080x1920), 1:1 (1080x1080), 4:5 (1080x1350). Un seul ou une déclinaison ?
3. **Cadence** : 25 (TV/Europe, défaut), 24 (cinéma), 30 (réseaux), 60 (UI). Respecter celle du projet existant.
4. **Durée totale** et **répartition** : entrée / hold / sortie. Boucle (loop) souhaitée ?
5. **Marque** : logo (SVG / PNG ? fichier ?), couleurs (hex), polices, ton (premium, pop, tech...), références de mouvement.
6. **Contenu** : textes exacts (slogan, handles, URL, CTA), ordre de priorité, langue.
7. **Packshot / visuels** : fichiers fournis ? résolution ? transparence ?
8. **Son** : musique / voix ? synchro sur des temps forts ? (Cavalry exporte l'audio MP4 / QuickTime / WebM.)
9. **Sortie** : MP4 (H.264), ProRes, WebM, PNG séquence, GIF, Lottie ? Avec ou sans transparence ? Résolution finale ?
10. **Contraintes** : poids maximal, zones de sécurité de la plateforme, sous-titres, accessibilité.
11. **Scène existante** : travaille-t-on dans une scène ouverte ? Que ne faut-il pas toucher ?

Si l'utilisateur ne répond pas : défauts 1920x1080, 25 i/s, MP4 H.264, durée selon l'élément (logo 4 s, end-card 6 s, pastilles 4 s, slogan 4 s).

---

## 2. Structure de scène recommandée

```
Master (comp)
  CTRL_<Projet>            null : racine de transformation + paramètres
  P_Reveal                 value : le geste-source (seules keyframes)
  P_Delai_*                value : retards par bloc (timeOffset)
  P_Sortie / Sortie_opacite value : sortie pilotée
  Scene Palette            Fond / Surface / Texte / Accent
  <GROUPE>                 group : contenu (logo, carte, pastilles)
      éléments (shapes / textShape / duplicator)
  Anim_* / *_anim          autoAnimate connectés aux deformers des éléments
  Halo, Respiration        oscillator / noise (action secondaire)
```

- **Comps** : un comp « Master » par format ; déclinaisons = autres comps qui réutilisent le master via `api.createCompReference(compId)` (précomp). Un comp par livrable de rendu pour stabiliser la file de rendu.
- **Groupes** : un `group` par bloc fonctionnel (LOGO, CARTE, PASTILLES). Après regroupement, `api.centrePivot(id, true)` si on anime l'échelle ou la rotation.
- **Nulls de contrôle** : `CTRL_*` est la racine (`api.parent(groupe, ctrl)`). Déplacer / échelonner le null repositionne tout. Les paramètres exposés sont les nœuds `P_*` (valeurs, retards) rangés à côté ; les noter dans `notes` du null si besoin.
- **Palette de scène** : toutes les couleurs partagées sont des swatches (`addSceneSwatch`) connectés par `api.connect(pal, "array." + i, id, "material.materialColor")` (remplissage) ou `"stroke.strokeColor"` (contour). Convention : Fond, Surface, Texte, Accent (+ Accent2).
- **Nommage** (français, sans espaces inutiles) : `CTRL_`, `P_` (paramètre), `Anim_` ou `_anim` (autoAnimate), éléments par leur rôle (Anneau, Wordmark, Pastille_fond). Jamais « shape_3 ».
- **Ids** : les ids Cavalry (`basicShape#6`) sont stables pendant la vie de la scène, mais les variables JS ne persistent pas d'un `execute_script` à l'autre. Faire retourner les ids en dernière expression (JSON.stringify) ou les retrouver par `api.getAllSceneLayers()` + `api.getNiceName(id)`.

---

## 3. Boucle de travail avec le MCP

1. **`read_preamble`** (obligatoire une fois par session : `execute_script` refuse sinon). Il donne aussi l'état du comp actif (résolution, cadence, plage).
2. **Inspecter avant de construire** : ne jamais supposer une scène vide. `api.getChildren(api.getActiveComp())` et `api.getAllSceneLayers()` ; repérer ce qui appartient à l'utilisateur et ne pas y toucher. Mémoriser `const avant = api.getAllSceneLayers()` pour pouvoir nettoyer.
3. **Rechercher** : `search_docs` + `read_doc` (hints sous `mcp-hints/…` : `animation-easing`, `text-animation`, `duplicators-and-indexed-arrays`, `motion-graphics-elements`, `palettes`, `colour-and-shading`, `seamless-loops`) ; `search_layer_types` + `get_layer_definition` pour les attributs ; `search_api` + `get_api_function` pour les signatures ; `search_examples` / `read_example` pour des presets de production.
4. **`preflight_script`** : vérifie seulement la syntaxe, pas l'API (une connexion ratée passe).
5. **`execute_script`** : un geste logique par appel (un seul undo). Chaque appel est un contexte JS neuf. Retourner les ids créés.
6. **Vérifier visuellement** : `snapshot_layer` du comp entier (sans `layerId`) à plusieurs images : `frame` en paramètre (début, milieu d'entrée, fin d'entrée, hold, sortie). Un snapshot du comp est limité au cadre.
7. **Vérifier numériquement** : `api.getBoundingBox(id, true)` (espace monde, renvoie `{left, right, top, bottom, centre, width, height}`) échantillonné avec `api.setFrame(f)`. Plus précis qu'une image pour « est-ce dans le cadre / dans la zone de sécurité ».
8. **Scene hygiene** : un script qui échoue n'est pas annulé. Avant de relancer, supprimer les restes (`api.deleteLayer`). Un `execute_script` qui échoue sans message : isoler avec un petit script `try/catch` par étape (`T("etape", () => …)`) pour trouver la ligne fautive.
9. **Nettoyage final** : retirer tout calque de test ; vérifier `api.getAllSceneLayers().length` avant/après ; fichiers temporaires dans `api.getTempFolder() + "/cavalry-mcp-" + Date.now()` puis `cleanup_workspace`.

### Pièges vérifiés en pratique

- **`api.setStroke(id, true)` AVANT de régler `stroke.*`** : si on règle `stroke.trim` puis qu'on appelle `setStroke`, le réglage est écrasé (le trim restait à false).
- **`api.removeArrayIndex(id, attr)` n'a que 2 arguments** (pas d'index) ; les tableaux (`stringArray`, `valueArray`…) naissent avec 1 entrée : l'écrire (`array.0`) puis `addArrayIndex` renvoie l'index suivant.
- **Un attribut déjà connecté refuse une nouvelle connexion** (« The destination attribute has an input ») : passer `true` en 5e argument de `api.connect` pour forcer.
- **`linearDistribution.size` est un scalaire** (étendue totale), pas un double2. `generator.direction` : 0 / 1 (horizontal / vertical). Le premier élément est en bas quand la direction est verticale.
- **Texte centré sur l'origine** : `autoWidth: true`, `autoHeight: true`, `textBoxSize: [1, 1]`, alignements 1/1, `position: [0, 0]`. Avec une boîte large fixe, le texte part d'un coin.
- **`textShape.backgroundShape`** attend une forme connectée ; elle ne se dessine pas toute seule en pastille. Pour des pastilles fiables : un rectangle arrondi dupliqué (calque fond) + un texte dupliqué (calque texte).
- **`api.get` renvoie `null` sur un attribut connecté** ; vérifier par `api.getInConnection(id, attr)` (renvoie par exemple `value#3.out`) ou visuellement.
- **`autoAnimate.progress`** a 2 keyframes par défaut : les supprimer avant de le connecter.
- **`api.setFrame` est borné au plage du comp**.
- **`api.set(compId, { resolution: [w, h], fps, startFrame, endFrame, playbackStart, playbackEnd, backgroundColor })`** : c'est la bonne façon de régler le comp actif.
- **Scene Palette partagée** : elle appartient à la scène de l'utilisateur. Si on y ajoute des swatches pour un test, les retirer ensuite avec `removeSceneSwatch(index)` (du dernier au premier).

---

## 4. Export et rendu

### 4.1 Mise en file par script
```js
const rq = api.addRenderQueueItem(api.getActiveComp());   // retourne l'id de l'item
// Les attributs de l'item (nom de fichier, format, chemin, échelle) :
JSON.stringify(api.getAttributes(rq));                    // lister avant d'écrire
api.render(rq);                // rendu au premier plan
// api.backgroundRender(rq);   // rendu en arrière-plan (la scène reste utilisable)
// api.renderAll(); api.backgroundRenderAll(); api.getRenderQueueItems();
```
Toujours lister les attributs de l'item (`getAttributes`) avant de les régler : les identifiants dépendent du format choisi. Demander confirmation à l'utilisateur avant d'écrire des fichiers (chemin de sortie) et avant un rendu long.

### 4.2 Formats (Render Manager)

| Format | Type | Alpha | Audio | Usage |
|---|---|---|---|---|
| MP4 (H.264) | Vidéo | non | oui | Diffusion web / réseaux, livraison standard |
| QuickTime (ProRes 422 HQ / LT / Proxy) | Vidéo | non | oui | Master de post-production, montage |
| QuickTime ProRes 4444 / 4444 XQ | Vidéo | **oui** | oui | Habillage avec transparence |
| WebM (VP8 / VP9 / AV1) | Vidéo | **non** dans Cavalry | oui | Web léger, sans alpha |
| PNG (séquence) | Image | oui | non | Master image, 16 bits possible |
| JPEG (séquence) | Image | non | non | Aperçus |
| GIF | Image | oui (seuil) | non | Petits loops, aperçus |
| APNG / WebP | Image | oui | non | Animation web avec alpha |
| SVG | Vecteur | oui | non | Séquence de SVG (pas d'animation) |
| Sprite Sheet | Image | oui | non | Jeux, avec JSON des cellules |
| Lottie | Vecteur / code | oui | non | Web / mobile natif |
| Audio seul | Audio | non | oui | AAC / AIFF / WAV |

Réglages utiles : `Resolution Scale` (0,5 pour un essai), `Frame Range Mode` (comp / lecture / personnalisée), `Render Quality` (Low / Lowest pour tests), `Padding` (numérotation des séquences), `Background Rendering`, rendus dynamiques (`Dynamic Render`) pour décliner des variantes, retimage à l'export (onglet Compositions, `Retime Render`).

### 4.3 Règles de choix

- **MP4 H.264** : limité à **9 437 184 pixels** (4096x2304 maximum en 16:9). Au-delà, réduction proportionnelle automatique. Qualité en fonction du support : web 8 à 12 Mb/s en 1080p.
- **Transparence** : mettre **Background Alpha à 0** dans les réglages du comp (couleur de fond non utilisée), puis ProRes 4444 / PNG séquence / APNG / WebP / GIF. **WebM n'a pas d'alpha dans Cavalry.** MP4 non plus.
- **Résolutions** : 1920x1080 (standard), 3840x2160 (4K, mais voir limite MP4 : 4096x2304 max), 1080x1920 (vertical), 1080x1080 / 1080x1350 (fil social).
- **Boucles** : `endFrame = N - 1`, vérifier frame 0 vs frame N en élargissant temporairement `endFrame`.
- **Retiming** : on peut allonger à l'export, plutôt que raccourcir ; les animations par images entières (vidéo, séquences) dupliquent des images à l'étirement.
- **CLI sans interface** : réservé à la licence Enterprise.

### 4.4 Limites de Lottie (à annoncer avant de promettre)

Non supportés : tous les **filtres** (flous, niveaux…), shaders Noise / SkSL / Color / Shape-to-Shader, dégradés **conique / sweep**, `Stroke > Dash Pattern`, `Transform > Skew`, **opacité de forme** (utiliser `Fill > Alpha` / `Stroke > Alpha`), courbes d'animation en boucle, **track mattes** (utiliser un masque d'écrêtage). Le **texte** est exporté en formes (non éditable). Les images sont référencées dans un dossier `images`, pas incorporées ; pas de séquences d'images. Les déformeurs, magic easing sur chemins, duplicators et rig controls fonctionnent mais produisent des fichiers lourds (« baking »). Réglage : attribut `Lottie Baking` (`forceLottieBake` : 0 auto, 1 maillage animé, 2 maillage + matériaux, 3 nuclear, 4 fixe).

Conséquence sur nos recettes : le halo flou (`featherAmount`) et l'opacité de forme ne survivent pas à l'export Lottie. Si Lottie est le livrable principal, l'annoncer et utiliser `Fill > Alpha`, pas de flou.

---

## 5. Recettes complètes

Convention de tous les scripts : comp 1920x1080, 25 i/s, couleurs en Scene Palette, un nœud source `P_*` keyframé, retards par nœud `value` (`timeOffset` négatif = démarre plus tard), `autoAnimate` branché sur `progress`.

Chaque recette est autonome : crée son comp, ses swatches, ses nœuds. À relancer proprement : supprimer d'abord le comp et les nœuds de la tentative précédente. Les swatches ajoutés restent dans la Scene Palette de la scène (en tenir compte).

### Recette 1 : logo reveal (4 s, 100 images)

Anneau dessiné (trim), monogramme (échelle + fondu via autoAnimate), wordmark caractère par caractère, filet, respiration de l'ensemble. 1 geste keyframé (`P_Reveal`, 0 -> 100 en 30 images, `SlowOut`) ; `P_Delai_Mono` (6), `P_Delai_Mot` (14), `P_Delai_Filet` (26) sont des retards réglables.

```js
// ===== RECETTE 1 : LOGO REVEAL PROCEDURAL =====
const comp = api.createComp("Logo_Reveal"); api.setActiveComp(comp);
api.set(comp,{resolution:[1920,1080],fps:25,startFrame:0,endFrame:99,playbackStart:0,playbackEnd:99,backgroundColor:"#0e1116"});
const pal = api.getScenePalette();
const FOND=api.addSceneSwatch("#0e1116","Fond"), ACC=api.addSceneSwatch("#ff5a36","Accent"), TXT=api.addSceneSwatch("#f4efe6","Texte");
const sw = i => "array."+i;

// CTRL : un seul geste keyframé, tout le reste en dérive
const ctrl = api.create("null","CTRL_Logo");
const src = api.create("value","P_Reveal");                 // 0 -> 100 sur 30 images
api.keyframe(src,0,{value:0}); api.keyframe(src,30,{value:100});
api.magicEasing(src,"value",0,"SlowOut");
const delayed = (name, frames) => { const v=api.create("value",name); api.connect(src,"id",v,"value"); api.set(v,{timeOffset:-frames}); return v; };
const pMot = delayed("P_Delai_Mot",14), pFilet = delayed("P_Delai_Filet",26), pMono = delayed("P_Delai_Mono",6);

// Anneau : trim piloté par la source
const ring = api.primitive("ellipse","Anneau");
api.setFill(ring,false); api.setStroke(ring,true);            // d'abord activer le trait…
api.set(ring,{"generator.radius":[150,150],"stroke.width":12,"stroke.capStyle":1,"stroke.trim":true}); // …puis régler stroke.*
api.connect(pal,sw(ACC),ring,"stroke.strokeColor");
api.connect(src,"id",ring,"stroke.trimEnd");

// Monogramme : autoAnimate (échelle + fondu), progress relié au retard
const mono = api.create("textShape","Monogramme");
api.set(mono,{text:"C",fontSize:190,horizontalAlignment:1,verticalAlignment:1,autoWidth:true,autoHeight:true,textBoxSize:[1,1],position:[0,0]});
api.set(mono,{"font":{font:"Lato",style:"Black"}});
api.connect(pal,sw(TXT),mono,"material.materialColor");
const aaM = api.create("autoAnimate","Mono_entree");
api.set(aaM,{useLevels:false,positionMode:0,scaleMode:1,opacityMode:1,scaleFromMode:1});
for (const f of api.getKeyframeTimes(aaM,"progress")) api.deleteKeyframe(aaM,"progress",f);
api.connect(pMono,"id",aaM,"progress");
api.connect(aaM,"id",mono,"deformers");

// Wordmark par caractère
const word = api.create("textShape","Wordmark");
api.set(word,{text:"ACME STUDIO",fontSize:84,letterSpacing:14,horizontalAlignment:1,verticalAlignment:1,autoWidth:true,autoHeight:true,textBoxSize:[1,1],position:[0,-250]});
api.connect(pal,sw(TXT),word,"material.materialColor");
const aaW = api.create("autoAnimate","Mot_entree");
api.set(aaW,{useLevels:true,levelMode:3,positionMode:2,angleDistance:[90,60],scaleMode:0,opacityMode:1,timingMode:0,timeOffset:-10});
for (const f of api.getKeyframeTimes(aaW,"progress")) api.deleteKeyframe(aaW,"progress",f);
api.connect(pMot,"id",aaW,"progress");
api.connect(aaW,"id",word,"deformers");

// Filet : échelle X = valeur 0..100 x 1 % (strength 1)
const rule = api.primitive("rectangle","Filet");
api.set(rule,{"generator.dimensions":[420,6],position:[0,-195]});
api.connect(pal,sw(ACC),rule,"material.materialColor");
const k = api.create("value","Filet_echelle"); api.set(k,{strength:1}); api.connect(pFilet,"id",k,"value");
api.connect(k,"id",rule,"scale.x");

// Groupe + respiration (oscillator : 1 cycle en 4 s -> boucle propre)
const logo = api.create("group","LOGO");
[ring,mono,word,rule].forEach(c=>api.parent(c,logo));
api.parent(logo,ctrl);
const osc = api.create("oscillator","Respiration");
api.set(osc,{minimum:0.985,maximum:1.015,frequency:0.25,strengthToZero:false});
api.connect(osc,"id",logo,"scale");
JSON.stringify({comp,logo,ctrl,src,ring,mono,word,rule,osc})
```
Vérification : `snapshot_layer` aux images 12 (anneau en cours, monogramme apparaît), 40 (tout en place), 90 (hold avec respiration).
Réglages sans keyframe : durée du geste = déplacer la 2e keyframe de `P_Reveal` ; retards = `timeOffset` des `P_Delai_*` ; teinte = swatch Accent ; texte = attribut `text`.
Remarque : la respiration agit sur l'échelle du groupe depuis l'origine : si le filet « glisse », centrer le pivot du groupe (`api.centrePivot(logo, true)`).

### Recette 2 : slogan texte par mot (4 s, 100 images)

Entrée mot par mot, mots clés en accent via regex, sortie par la même valeur source qui redescend de 100 à 0. Un seul nœud `P_Progress` à 4 keyframes (entrée, hold, sortie) ; `autoAnimate` au niveau des mots.

Durée de hold : 6 mots -> ~2,4 s de hold (voir règle dans `motion-principles.md`) ; ici entrée terminée en image 24, hold jusqu'à 80, sortie en 94.

```js
// ===== RECETTE 2 : SLOGAN PAR MOT =====
const comp = api.createComp("Slogan_Mots"); api.setActiveComp(comp);
api.set(comp,{resolution:[1920,1080],fps:25,startFrame:0,endFrame:99,playbackStart:0,playbackEnd:99,backgroundColor:"#0e1116"});
const pal = api.getScenePalette();
const ACC=api.addSceneSwatch("#ff5a36","Accent"), TXT=api.addSceneSwatch("#f4efe6","Texte");
const ctrl = api.create("null","CTRL_Slogan");

// Geste-source unique : entrée -> hold -> sortie (progress 0 -> 100 -> 0)
const src = api.create("value","P_Progress");
api.keyframe(src,4,{value:0}); api.keyframe(src,24,{value:100}); api.keyframe(src,80,{value:100}); api.keyframe(src,94,{value:0});
api.magicEasing(src,"value",4,"SlowOut"); api.magicEasing(src,"value",80,"SlowIn");

const t = api.create("textShape","Slogan");
api.set(t,{text:"Chaque mot compte,\nchaque page respire.",fontSize:96,lineSpacing:8,
  horizontalAlignment:1,verticalAlignment:1,autoWidth:true,autoHeight:true,textBoxSize:[1,1],position:[0,0]});
api.set(t,{"font":{font:"Lato",style:"Bold"}});
api.connect(pal,"array."+TXT,t,"material.materialColor");

// Mots-clés en accent (regex, non destructif)
const hl = api.create("applyTextMaterial","Mots_accent");
api.set(hl,{mode:0,indexMode:1,regex:"compte|respire"});      // mode 0 = regex, indexMode 1 = mot
api.connect(hl,"id",t,"materialBehaviours");
api.connect(pal,"array."+ACC,hl,"material.materialColor");

// Un seul autoAnimate par mot, progress piloté par la source
const aa = api.create("autoAnimate","Mots_anim");
api.set(aa,{useLevels:true,levelMode:2,positionMode:2,angleDistance:[90,70],scaleMode:0,opacityMode:1,timingMode:0,timeOffset:-14});
for (const f of api.getKeyframeTimes(aa,"progress")) api.deleteKeyframe(aa,"progress",f);
api.connect(src,"id",aa,"progress");
api.connect(aa,"id",t,"deformers");
api.parent(t,ctrl);
JSON.stringify({t,aa,src,hl})
```
Vérifier : `getBoundingBox(t, true)` à l'image 50 : centre proche de (0, 0) ; largeur environ 880 px, donc dans la zone de sécurité (+/- 864).
Réglages sans keyframe : vitesse d'enchaînement des mots = `timeOffset` de l'autoAnimate (-14 = 14 images au total entre le premier et le dernier mot) ; mots en accent = champ `regex` ; texte = attribut `text` (garder les `\n` pour l'équilibre des lignes).

### Recette 3 : pastilles réseaux sociaux en cascade (4 s, 100 images)

Duplicator vertical de 5 pastilles (calque fond arrondi + calque texte), libellés issus d'un `stringArray`, cascade par un unique `autoAnimate` (`levelMode: 1` = copies du duplicator) branché sur les deux duplicators, piloté par `P_Reveal`. Aucune keyframe sur les pastilles.

```js
// ===== RECETTE 3 : PASTILLES EN CASCADE =====
const comp = api.createComp("Pastilles_Cascade"); api.setActiveComp(comp);
api.set(comp,{resolution:[1920,1080],fps:25,startFrame:0,endFrame:99,playbackStart:0,playbackEnd:99,backgroundColor:"#0e1116"});
const pal = api.getScenePalette();
const FOND=api.addSceneSwatch("#0e1116","Fond"), ACC=api.addSceneSwatch("#ff5a36","Accent"), TXT=api.addSceneSwatch("#f4efe6","Texte");
const HANDLES=["@acmestudio","Instagram","TikTok","YouTube","LinkedIn"], N=HANDLES.length, PITCH=130;

const ctrl = api.create("null","CTRL_Pastilles");
const src = api.create("value","P_Reveal");                 // geste-source : 0 -> 100 en images 6..30
api.keyframe(src,6,{value:0}); api.keyframe(src,30,{value:100});
api.magicEasing(src,"value",6,"SlowOut");

// Libellés : stringArray (naît avec 1 entrée : on l'écrit puis on ajoute les suivantes)
const sa = api.create("stringArray","Libelles");
api.set(sa,{"array.0":HANDLES[0]});
for (let i=1;i<N;i++){ const idx=api.addArrayIndex(sa,"array"); api.set(sa,{["array."+idx]:HANDLES[i]}); }

// Gabarit fond : rectangle arrondi
const rect = api.primitive("rectangle","Pastille_fond");
api.set(rect,{"generator.dimensions":[420,92],"generator.cornerRadius":46});
api.connect(pal,"array."+ACC,rect,"material.materialColor");

// Gabarit texte : un libellé par copie (l'index du duplicator choisit l'entrée du tableau)
const lab = api.create("textShape","Pastille_texte");
api.set(lab,{fontSize:40,horizontalAlignment:1,verticalAlignment:1,autoWidth:true,autoHeight:true,textBoxSize:[1,1]});
api.set(lab,{"font":{font:"Lato",style:"Bold"}});
api.connect(sa,"out",lab,"text");
api.connect(pal,"array."+FOND,lab,"material.materialColor");

// Deux duplicators identiques (même distribution), un pour le fond, un pour le texte
const mkDup = (name, shape) => { const d=api.create("duplicator",name);
  api.connect(shape,"id",d,"shapes");
  api.setGenerator(d,"generator","linearDistribution");
  api.set(d,{"generator.count":N,"generator.direction":1,"generator.size":(N-1)*PITCH}); // size = scalaire : étendue totale
  return d; };
const dupFond = mkDup("Cascade_fonds", rect), dupTxt = mkDup("Cascade_textes", lab);

// Entrée procédurale : UN autoAnimate (niveau « copies de duplicator ») branché sur les deux
const aa = api.create("autoAnimate","Cascade_entree");
api.set(aa,{useLevels:true,levelMode:1,positionMode:2,angleDistance:[90,90],scaleMode:1,opacityMode:1,timingMode:0,timeOffset:-18});
for (const f of api.getKeyframeTimes(aa,"progress")) api.deleteKeyframe(aa,"progress",f);
api.connect(src,"id",aa,"progress");
api.connect(aa,"id",dupFond,"deformers");
api.connect(aa,"id",dupTxt,"deformers");

const g = api.create("group","PASTILLES");
api.parent(dupFond,g); api.parent(dupTxt,g); api.parent(g,ctrl);
JSON.stringify({g,dupFond,dupTxt,aa,src,sa})
```
Contrôle : `snapshot_layer` aux images 22 (cascade en cours, la première pastille est en bas : direction verticale = premier élément en bas) et 70 (tout en place).
Réglages sans keyframe : nombre de pastilles = `generator.count` des deux duplicators + une entrée de plus dans `stringArray` ; écart = `generator.size` ; durée de la cascade = `timeOffset` de l'autoAnimate ; sens = `reverseTimeOffset` ou `generator.direction` ; couleurs = swatches. Pour des couleurs différentes par pastille : un `colorArray` (ex. `api.createColorArrayFromPalette`) connecté à `shapeMaterial.materialColor` de la forme template, ou un `shaderArray`.
Largeur fixe de pastille : acceptable pour des libellés de 8 à 10 caractères ; au-delà, augmenter `generator.dimensions` ou réduire `fontSize`.
Variante stagger classique (alternative à `autoAnimate`) : keyframer UNE fois la forme template (opacité / position) puis `api.connect(stagger, "id", dup, "shapeTimeOffset")` avec `stagger.maximum` = délai total en images.

### Recette 4 : end-card packshot (6 s, 150 images)

Halo ambiant qui dérive (oscillator), packshot (placeholder), wordmark par caractère, slogan par mot, CTA (pastille + texte), URL, sortie en fondu. Géste-source `P_Reveal` (0 -> 100 sur 28 images) ; chaque bloc a un retard (`P_Delai_n`) créé par une fabrique ; sortie par `P_Sortie` (0 -> 100, images 134 à 149) reliée à l'opacité du groupe.

Mise en page (16:9, titre-safe respectée) : packshot à x = -380, colonne de texte alignée à gauche en x = +60, CTA centré en x = +290.

```js
// ===== RECETTE 4 : END-CARD PACKSHOT 6 s =====
const comp = api.createComp("EndCard_Packshot"); api.setActiveComp(comp);
api.set(comp,{resolution:[1920,1080],fps:25,startFrame:0,endFrame:149,playbackStart:0,playbackEnd:149,backgroundColor:"#0e1116"});
const pal = api.getScenePalette();
const ACC=api.addSceneSwatch("#ff5a36","Accent"), TXT=api.addSceneSwatch("#f4efe6","Texte"), SOM=api.addSceneSwatch("#1c222c","Surface");
const col=(id,attr,i)=>api.connect(pal,"array."+i,id,attr);

// CTRL + geste-source + sortie
const ctrl = api.create("null","CTRL_EndCard");
const src = api.create("value","P_Reveal");
api.keyframe(src,0,{value:0}); api.keyframe(src,28,{value:100});
api.magicEasing(src,"value",0,"SlowOut");
const out = api.create("value","P_Sortie");
api.keyframe(out,134,{value:0}); api.keyframe(out,149,{value:100});
api.magicEasing(out,"value",134,"SlowIn");
const fade = api.create("value","Sortie_opacite");
api.set(fade,{strength:-100,offset:100});                  // opacité = 100 - sortie
api.connect(out,"id",fade,"value");

// Fabrique « apparition » : valeur retardée + autoAnimate dérivé (non destructif)
const reveal = (target, delay, opts) => {
  const d = api.create("value","P_Delai_"+delay); api.connect(src,"id",d,"value"); api.set(d,{timeOffset:-delay});
  const a = api.create("autoAnimate","Anim_"+delay);
  api.set(a,Object.assign({positionMode:2,angleDistance:[90,60],scaleMode:0,opacityMode:1,timingMode:0},opts||{}));
  for (const f of api.getKeyframeTimes(a,"progress")) api.deleteKeyframe(a,"progress",f);
  api.connect(d,"id",a,"progress"); api.connect(a,"id",target,"deformers"); return a;
};
const text = (name,str,size,pos,align,style) => { const t=api.create("textShape",name);
  api.set(t,{text:str,fontSize:size,horizontalAlignment:align,verticalAlignment:1,autoWidth:true,autoHeight:true,textBoxSize:[1,1],position:pos});
  api.set(t,{"font":{font:"Lato",style:style||"Regular"}}); col(t,"material.materialColor",TXT); return t; };

// Fond : halo flou qui dérive (action secondaire continue)
const halo = api.primitive("ellipse","Halo");
api.set(halo,{"generator.radius":[520,520],position:[-380,40],featherAmount:220,opacity:35});
col(halo,"material.materialColor",ACC);
const drift = api.create("oscillator","Halo_derive");
api.set(drift,{minimum:-30,maximum:30,frequency:0.1667,strengthToZero:false});   // 1 cycle / 6 s
api.connect(drift,"id",halo,"position.y");

// Packshot (placeholder) : remplacer par un footage (api.loadAsset + api.addAssetToComp)
const prod = api.primitive("rectangle","Packshot");
api.set(prod,{"generator.dimensions":[420,600],"generator.cornerRadius":18,position:[-380,0]});
col(prod,"material.materialColor",SOM);
reveal(prod,6,{positionMode:0,scaleMode:1,scaleFromMode:1});

// Wordmark (caractères), slogan (mots), CTA (pastille + texte), URL
const word = text("Wordmark","ACME STUDIO",96,[60,170],0,"Black");
api.set(word,{letterSpacing:10});
reveal(word,18,{useLevels:true,levelMode:3,timeOffset:-10,angleDistance:[90,50]});
const slog = text("Slogan","Chaque page respire.",52,[60,60],0);
reveal(slog,30,{useLevels:true,levelMode:2,timeOffset:-8});
const pill = api.primitive("rectangle","CTA_fond");
api.set(pill,{"generator.dimensions":[460,96],"generator.cornerRadius":48,position:[290,-90]});
col(pill,"material.materialColor",ACC);
reveal(pill,44,{positionMode:2,scaleMode:1,scaleFromMode:1});
const cta = text("CTA_texte","Disponible en librairie",36,[290,-90],1,"Bold");
reveal(cta,48,{useLevels:true,levelMode:2,timeOffset:-6});
const url = text("URL","acme-studio.com",34,[60,-230],0);
reveal(url,60,{});

// Groupe de sortie piloté par une seule valeur
const card = api.create("group","CARTE");
[prod,word,slog,pill,cta,url].forEach(c=>api.parent(c,card));
api.connect(fade,"id",card,"opacity");
api.parent(halo,ctrl); api.parent(card,ctrl);
JSON.stringify({card,ctrl,children:api.getChildren(card)})
```
Vérifications : `snapshot_layer` aux images 30 (packshot et wordmark en cours), 100 (tout lisible : hold), 145 (fondu de sortie). Hold lisible total environ 3,5 s (images 60 à 134).
Réglages sans keyframe : retards = `timeOffset` des `P_Delai_*` ; durée du geste = 2e keyframe de `P_Reveal` ; instant de la sortie = keyframes de `P_Sortie` ; textes = `text` ; accent = swatch ; remplacer le packshot : charger l'image (`api.loadAsset(chemin, false)` puis `api.addAssetToComp(idAsset)`), et brancher le `reveal` sur le calque footage créé.
Pour la version 9:16 : changer `resolution` en `[1080,1920]` et empiler packshot (haut, y environ +250) puis texte (bas), colonne centrée, en tenant compte des marges haute (250 px) et basse (340 à 420 px) des plateformes.

---

## 6. Vérifications types après exécution

```js
// Positions échantillonnées (dans le cadre ? dans la zone de sécurité ?)
const track=[];
for (const f of [0,25,50,100,149]){ api.setFrame(f); const b=api.getBoundingBox(CARTE_ID,true);
  track.push({f,left:Math.round(b.left),right:Math.round(b.right),top:Math.round(b.top),bottom:Math.round(b.bottom)}); }
JSON.stringify(track)
```
Titre-safe en 1080p : left >= -864, right <= 864, top <= 486, bottom >= -486.

```js
// Hygiène : ce que le script a ajouté
const avant = /* api.getAllSceneLayers() pris avant */ [];
const nouveaux = api.getAllSceneLayers().filter(i => avant.indexOf(i) < 0);
JSON.stringify(nouveaux.map(i => i + ":" + api.getNiceName(i)))
```

Boucle (si demandée) :
```js
const comp=api.getActiveComp(); const N=api.get(comp,"endFrame")+1;
api.set(comp,{endFrame:N}); api.setFrame(0); const a=api.getBoundingBox(ID,true).centre.x;
api.setFrame(N); const b=api.getBoundingBox(ID,true).centre.x; api.set(comp,{endFrame:N-1});
Math.abs(a-b)<1e-3 ? "boucle ok" : "couture visible"
```

---

## 7. Livraison

1. Nommer le comp final, vérifier cadence, résolution, plage, `Background Alpha` (0 si alpha).
2. Rendu d'essai `Resolution Scale` 0,5, visionner entièrement, appliquer la checklist de `motion-principles.md` (sections 11 et 12).
3. Rendu final, vérifier le fichier (durée, résolution, alpha, audio).
4. Rendre compte : ce qui a été créé (comps, nœuds de contrôle), comment régler (délais, couleurs, textes), ce qui est hors périmètre (Lottie : filtres non exportés), chemin de sortie.
5. Nettoyer : calques de test supprimés, swatches temporaires retirés, fichiers temporaires nettoyés (`cleanup_workspace`).
