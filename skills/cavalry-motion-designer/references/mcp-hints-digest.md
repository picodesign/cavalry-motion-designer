# Digest des hints MCP Cavalry (text-animation, sub-mesh, colour-and-shading, palettes, compound-graphs, seamless-loops, wavy-paths, data-visualisation)

Source : `read_doc mcp-hints/<nom>`. Hors périmètre ici : animation-easing, duplicators-and-indexed-arrays, motion-graphics-elements.
Convention : code et noms d'API en anglais, explications en français.

---

## 1. TEXT ANIMATION

### 1.1 Ancrage `position` / alignement

`position` épingle le **pivot** du texte. Le pivot dépend de `horizontalAlignment` + `verticalAlignment`.

| H | V | Pivot au |
|---|---|---|
| 0 Left (défaut) | 0 Top (défaut) | coin haut-gauche du bbox |
| 1 Centre | 1 Middle | centre du bbox |
| 2 Right | 2 Bottom | bas-droite |
| 3 Justify | 3 Baseline | bord gauche / baseline 1re ligne |

Centrer sur l'origine :
```js
const t = api.create("textShape", "Hello");
api.set(t, { text: "Hello, World!", horizontalAlignment: 1, verticalAlignment: 1, position: [0, 0] });
```
Alternatives :
```js
api.centrePivot(t, true); api.set(t, { position: [0, 0] });
// ou, après mise en forme finale (texte/police/manipulators changent le bbox) :
const bb = api.getBoundingBox(t, false); // {x,y,width,height,centre:{x,y},left,right,top,bottom}
api.set(t, { position: [-bb.centre.x, -bb.centre.y] });
```

### 1.2 Pièges `autoWidth` / `autoHeight` / `textBoxSize`
- Défauts : `autoHeight:false`, `autoWidth:false`, `textBoxSize:[600,300]` -> `position` ancre la **boîte**, pas les glyphes.
- `autoHeight:true` garde la largeur de boîte mais l'ancre dérive (le texte peut apparaître des centaines d'unités plus bas). Idem `autoWidth` avec grande `textBoxSize.x`.
- Recette fiable : `autoWidth:true, autoHeight:true, textBoxSize:[1,1]`, OU défauts puis `getBoundingBox` et offset `-bbox.left,-bbox.top`.
- `autoWidth` off = le texte wrap sur plusieurs lignes : si inattendu sur un snapshot, l'activer.

### 1.3 Carte de fond intégrée
`textShape` a son propre fond auto-ajusté : ne PAS construire un `basicShape` derrière. Attributs : `backgroundMode` (enum, vérifier avec `get_layer_definition` la valeur "carte pleine"), `backgroundPadding` `[W,H]`, `cornerRadius` / `radiusTop` / `radiusBottom` / `chamfer`, `ascenderAdjustment` / `descenderAdjustment` pour resserrer.

### 1.4 Les 5 points de connexion de `textShape`

| Slot | Type | Contenu |
|---|---|---|
| `text` | attr richText | `out` d'un `stringGenerator` (ou `string`) |
| `manipulators` | liste | wrappers `stringManipulator`, empilés |
| `styleBehaviours` | liste | `applyTypeface`, `applyFontSize`, `applyFontStyle`, `applyCharacterSpacing`, `applyOpenType` |
| `materialBehaviours` | liste | `applyTextMaterial` |
| `deformers` | attr | `autoAnimate`, `subMesh`, chaînes de falloff |

`textShape` n'a **aucun slider "caractères visibles"** : utiliser `resizeString` (côté string) ou `autoAnimate` opacité (côté géométrie).

### 1.5 NodeTypes exacts
- Opérateurs string (superType `stringOperator`, dans `stringManipulator.generator`) : `transitionString`, `resizeString`, `shuffleString`, `subString`, `regexString`, `replaceString`, `changeStringCase`, `unicodeManipulator`, `concatenateStringArray`.
- Moteurs texte (superType `textEngine`, dans `stringGenerator.generator`) : `textValue` (nombre->string, défaut), `textNumber` (nombre aléatoire), `textHash`, `textHex`, `textBlockUnicode`, `textFormatted` (`{0}`,`{1}`), `textDate`, `formattedDateAndTime`, `textTimecode`.
- Style : `applyTypeface`, `applyFontSize`, `applyFontStyle`, `applyCharacterSpacing`, `applyOpenType`, `applyTextMaterial`.

### 1.6 Pattern host / sub-UI
`stringManipulator` et `stringGenerator` sont des **wrappers** : l'opérateur vit dans le sub-UI `generator`. Défauts : `shuffleString` (manipulator), `textValue` (generator). Changer : `api.setGenerator(id, "generator", "<nodeType>")`, puis attributs en chemin pointé `generator.<attr>` (appeler `api.getAttributes(id)` après le swap).
Ne JAMAIS connecter un `transitionString`/`resizeString` nu à `manipulators`.

### 1.7 Quel outil pour quoi

| Objectif | Outil |
|---|---|
| Une string se transforme en une autre | `transitionString` dans `stringManipulator` -> `manipulators` |
| A sort, B entre | 2 `textShape` + 2 `autoAnimate` à courbes opposées |
| Machine à écrire | `resizeString`, `indexMode:0`, `percentage` keyframé |
| Entrée mot par mot | `autoAnimate` `useLevels:true, levelMode:2` |
| Entrée lettre par lettre | `autoAnimate` `useLevels:true, levelMode:3` |
| Glitch / scramble | `shuffleString` (`timeOffset` piloté par `stagger`) |
| Cycle de pictos | `textBlockUnicode` |
| Compteur / countdown | `stringGenerator` + `textValue`, keyframer `generator.number` |
| Ticker aléatoire | `stringGenerator` + `textNumber` |
| Timecode / horloge | `textTimecode` ou `formattedDateAndTime` |
| Couleur par mot | `applyTextMaterial` (`mode:0` Regex, `mode:1` Indices) |
| Taille par mot | `applyFontSize` (+ `rangeFalloff`) |
| Axe de police variable | `applyTypeface` + oscillator/keyframe sur `fontAxes.0` |

### 1.8 Recettes

Morph "Hello" -> "World" :
```js
const tId = api.create("textShape", "Morph");
api.set(tId, { text: "Hello", horizontalAlignment: 0 });
const m = api.create("stringManipulator", "Transition");
api.setGenerator(m, "generator", "transitionString");
api.set(m, { "generator.destinationText": "World", "generator.mode": 0 }); // 0 = Percentage
api.connect(m, "id", tId, "manipulators");
api.keyframe(m, 0,  { "generator.percentage": 0 });
api.keyframe(m, 60, { "generator.percentage": 100 });
```

Typewriter (aligner à gauche : le layout ne bouge pas) :
```js
const tId = api.create("textShape", "Typewriter");
api.set(tId, { text: "Welcome to Cavalry", horizontalAlignment: 0 });
const m = api.create("stringManipulator", "Reveal");
api.setGenerator(m, "generator", "resizeString");
api.set(m, { "generator.mode": 0, "generator.indexMode": 0, "generator.directionMode": 1 }); // 1 = Erase from End = révèle depuis le début
api.connect(m, "id", tId, "manipulators");
api.keyframe(m, 0,  { "generator.percentage": 0 });
api.keyframe(m, 48, { "generator.percentage": 100 });
```

A sort / B entre (preset de référence : `assets/Presets/Text/Scale Random Words.js`) :
```js
const mk = (name, txt, k0, k1, p0, p1) => {
  const t = api.create("textShape", name); api.set(t, { text: txt });
  const a = api.create("autoAnimate", name + " Anim");
  api.set(a, { positionMode: 0, scaleMode: 1, useLevels: true, levelMode: 2, timingMode: 1, groupByParent: true, reverseParentOrder: true });
  api.connect(a, "id", t, "deformers");
  for (const f of api.getKeyframeTimes(a, "progress")) api.deleteKeyframe(a, "progress", f); // purge défauts
  api.keyframe(a, k0, { progress: p0 }); api.keyframe(a, k1, { progress: p1 });
};
mk("A", "First message", 0, 20, 100, 0);   // sortie
mk("B", "Second message", 10, 30, 0, 100); // entrée
```

Texte sur chemin (mode natif, pas de deformer) :
```js
const txt = api.create("textShape", "On Path");
api.set(txt, { text: "I am auto generated", horizontalAlignment: 0 });
const path = api.create("editableShape", "S Path"); // points via api.setEditablePath (section 7)
api.connect(path, "id", txt, "textPath");   // slot unique nodeId
api.keyframe(txt, 0,   { pathTravel: 0 });
api.keyframe(txt, 220, { pathTravel: 100 });
```
- `pathTravel` = pourcentage, NON clampé (<0 et >100 valides). Ne pas sonder avec `api.set` sur un attribut keyframé (écrit un keyframe parasite).
- `pathPush` (float) = décalage perpendiculaire ; `pathLoop` (bool) = boucle sur chemin fermé.
- **Runway** : à `pathTravel:0` la tête est au début du chemin, le corps est déjà à l'écran. Pour une entrée propre hors cadre, prolonger la GÉOMÉTRIE du chemin d'au moins une longueur de texte au-delà de chaque bord du comp (pas les valeurs de travel).
- `textPath` écrase les transforms par caractère : ne pas combiner avec `autoAnimate` position modes.

Style par plage :
```js
const mat = api.create("applyTextMaterial", "Highlight");
api.set(mat, { mode: 0 /*Regex*/, indexMode: 1 /*Word*/, regex: "and", "material.materialColor": "#ff2266" });
api.connect(mat, "id", tId, "materialBehaviours");
```
Police variable : voir `assets/Presets/Text/Variable Font.js`.

### 1.9 Glyph soup / FUI (`textBlockUnicode`)

Plages Unicode : 48-57 chiffres ; 65-90 / 97-122 lettres ; 9472-9599 box drawing ; 9600-9631 blocs ; 9632-9727 formes géométriques ; 9728-9983 symboles divers ; 9984-10175 dingbats ; 8592-8703 flèches ; 8704-8959 maths.

Champ 12x4 :
```js
const t  = api.create("textShape", "Glyph Field");
const sg = api.create("stringGenerator", "Block");
api.setGenerator(sg, "generator", "textBlockUnicode");
api.set(sg, { "generator.linesPerParagraph": 4, "generator.wordsPerLine": 12, "generator.charsPerWord": 1,
              "generator.wordDelimiter": " ", "generator.mode": 0 }); // 0 = Unicode Code Point
api.connect(sg, "out", t, "text");
const r = api.create("random", "codepoints");
api.set(r, { minimum: 9632, maximum: 9727 });
api.connect(r, "id", sg, "generator.codePoint");
```
Grille parfaite (1 glyphe par copie de duplicator). **Piège** : le codePoint pousse son propre contexte Index, donc le `random` ignore l'index du duplicator -> brancher `duplicator.indexContext` dans `random.seed` :
```js
// t = textShape 1 glyphe (lines/words/chars = 1), sg branché sur t.text, r branché sur sg.generator.codePoint
const al = api.create("align", "centre glyph");           // glyphes souvent décentrés par rapport à l'origine de police
api.set(al, { x: 0, y: 0 }); api.connect(al, "id", t, "deformers");
const dup = api.create("duplicator", "glyph grid");
api.connect(t, "id", dup, "shapes");
api.connect(dup, "indexContext", r, "seed");             // clé du trick
api.set(dup, { "generator.count": [12, 4], "generator.size": [(12-1)*90, (4-1)*90] });
```
`mode:1` (String) remplace `codePoint` par `character`/`string` ; avec un `stringArray` sur `generator.string` pour cycler une liste fixe.

### 1.10 autoAnimate : référence

- `useLevels` (bool, déf. false) : DOIT être true pour lignes/mots/caractères.
- `levelMode` : 0 Custom, 1 Lines (ou enfants de Duplicator), 2 Words, 3 Characters (déf. 3).
- `progress` (0-100, keyframable) : **0 = en vol (hors scène/transparent/scale 0), 100 = au repos (état final)**. Entrée : 0->100 ; sortie : 100->0. Avec `opacityMode:1` (Fade Up) 0 = invisible ; avec `2` (Fade Down) l'inverse.
- `positionMode` : 0 None, 1 Slide From Composition Edge, 2 Drift (déf.), 3 Zoom. Drift/Zoom pour du rapide/punchy ; 1 si l'anim dure quelques secondes.
- `rotationMode` : 0 None, 1 Spin, 2-5 Swing From L/R/T/B, 6-7 Swing From Centre H/V.
- `scaleMode` : 0 None, 1 Scale Up, 2 Scale Down.
- `opacityMode` : 0 None, 1 Fade Up (déf.), 2 Fade Down.
- `timingMode` : 0 Normal, 1 Random (déf.), 2 Middle out.
- `timeOffset` (déf. -20) : étalement total en FRAMES (seulement si `useLevels`) ; y connecter un `stagger` pour une courbe custom.
- `groupByParent`, `parentTimingMode`, `reverseParentOrder` : parents (mots) avant enfants (lettres).
- `reverseTimeOffset` : dernière lettre en premier (utile pour éviter l'effet "concertina" en entrée depuis la gauche).
- Connecter `autoAnimate.id` -> `textShape.deformers` (attr, pas sub-UI).

### 1.11 Gotchas texte
- **`autoAnimate.progress` livre 2 keyframes par défaut (f0 -> 0, f24 -> 100)** qui polluent le timing : les supprimer d'abord :
  `for (const f of api.getKeyframeTimes(id,"progress")) api.deleteKeyframe(id,"progress",f);`
- `manipulators` exige le wrapper `stringManipulator`.
- `manipulators` REMPLACE le texte de base (`replaceBaseText()`) : `text` n'est plus source de vérité. Pour entrelacer plusieurs sources, utiliser le sub-UI `array`.
- `stringGenerator.generator` par défaut = `textValue` ; pour un autre moteur, `setGenerator` d'abord.
- Les `apply*` ciblent par DEUX attrs : `mode` (Regex/Indices/All) ET `indexMode` (Line/Word/Character). Oublier `indexMode` = no-op silencieux.
- `horizontalAlignment` recalcule le layout quand la longueur change : 0 pour typewriter, 1 pour morph symétrique.
- **`applyTypeface` : la famille est `font.font` (pas `font.family`)**, style `font.style` : `api.set(tf, { "font.font": "Inter", "font.style": "Bold" })`.
- Helpers police/mesure sur `cavalry`, pas `api` : `cavalry.getFontFamilies()`, `cavalry.measureText(text, fontFamily, fontStyle, fontSize)` (pour dériver la largeur exacte d'un filet/soulignement : `generator.dimensions.x`). `api.getFontFamilies` n'existe pas.
- **Enums `indexMode` différents** : `shuffleString` 0=Word,1=Line,2=Paragraph,3=Document ; `resizeString` 0=Character,1=Word,2=Line,3=Paragraph.

Presets utiles : `assets/Presets/Text/` (Countdown, Variable Font, Scale Random Words, Swing Random Words, Diagonal Slide, Fade Alternate Lines), `assets/Presets/Kinetic Type/Over and Over.js`.

---

## 2. SUB-MESH (`subMesh`)

Behaviour général pour animer les parties d'une shape : caractères de `textShape`, calques d'`svgShape`, ellipses d'une pre-comp, polygons d'un path. Se connecte dans `deformers` de la shape hôte ; les autres behaviours se connectent dans ses attributs par élément (`shapeRotation`, `shapePosition`, `shapeScale.x/.y`, `shapeVisibility`, `shapeTimeOffset`, `material`, `stroke`).

```js
api.connect(subMeshId, "id", shapeId, "deformers");
api.connect(behaviourId, "id", subMeshId, "shapeRotation");
```

### 2.1 subMesh vs autoAnimate

| Objectif | Outil |
|---|---|
| Entrée par caractère avec recette position/scale/opacité prête | `autoAnimate` (`useLevels:true, levelMode:3`) |
| Rig custom par caractère (rotation via noise, opacité via stagger...) | `subMesh` |
| Parties d'un `svgShape` | `subMesh` (autoAnimate = texte seulement) |
| Animation par Polygon (sous-path) | `subMesh` `mode:1` |
| Couper/gater des indices | `subMesh` + `javaScript` sur `shapeVisibility` |
| Remplacer fill/stroke par partie | `subMesh` (`material`/`stroke` + `fillReplacementMode`/`strokeReplacementMode`) |

### 2.2 Contexte (règle clé)
Pour chaque child-mesh, `subMesh` pousse : `Index`, `Count`, `ChildIndex`, `Position`, `TimeOffset` (additif, via `shapeTimeOffset`). Tout ce qui est branché sur `subMesh.shapeX` lit ces contextes comme dans un duplicator : un `random` se re-seede par index, un `stagger`/`oscillator` lisant Index donne séquence/vague, un `colorArray` cycle. Autre profondeur : utilitaire `contextIndex` avec `depth` explicite.

### 2.3 `levelMode`

| Val | Cible | `levels` |
|---|---|---|
| 0 Custom | plage de profondeurs `[levels.x, levels.y]` | libre |
| 1 Text Lines | lignes | forcé (1,1) |
| 2 Text Words | mots | forcé (2,2) |
| 3 Text Characters | caractères | forcé (3,3) |
| 4 All | toutes profondeurs | (0,maxDepth) auto |

Les niveaux changent si le texte est dans un Duplicator (+1). Pour un SVG : `levelMode:0` et ajuster `levels` (inspecter via `extractSubMeshes` ou `subMeshBoundingBox`).

### 2.4 Index Mode
`0` Unique : 0..N continu sur tout. `1` Child Index : redémarre à 0 par parent (même cycle de couleurs par mot). Équivaut à Duplicator dans Duplicator avec Use Index Context off.

### 2.5 Recettes
Rotation aléatoire par caractère :
```js
const t = api.create("textShape", "Wobble"); api.set(t, { text: "WOBBLE" });
const sm = api.create("subMesh", "Per-Char"); api.set(sm, { levelMode: 3 });
api.connect(sm, "id", t, "deformers");
const r = api.create("random", "Tilt"); api.set(r, { minimum: -25, maximum: 25 });
api.connect(r, "id", sm, "shapeRotation");
```
Parties de SVG :
```js
const sm = api.create("subMesh", "Logo Parts");
api.set(sm, { levelMode: 0, levels: { x: 1, y: 1 }, transformAroundCenter: true }); // scale autour du centre de chaque partie
api.connect(sm, "id", svg, "deformers");
const osc = api.create("oscillator"); api.set(osc, { minimum: 0.95, maximum: 1.05, frequency: 0.5 });
api.connect(osc, "id", sm, "shapeScale.x"); api.connect(osc, "id", sm, "shapeScale.y");
```
Couleur par caractère depuis palette :
```js
const pal = api.create("colorArray", "Palette"); // colours remplies via api.setAttributes
api.connect(pal, "id", sm, "material");
api.set(sm, { fillReplacementMode: 0 });   // 0 = Replace All
```
Gating d'indices (muter les caractères 1 et 4) :
```js
const js = api.create("javaScript", "Mute List");
api.set(js, { expression: "[1, 4].includes(ctx.index) ? 0 : 1;" });
api.connect(js, "id", sm, "shapeVisibility");
```
`ctx.index`, `ctx.count` dispo ; rampe : `ctx.index / (ctx.count - 1)`. Avancé : `ctx.layerId`/`ctx.attributeId` (doc `tech-info/scripting/context-module`).

**Expressions JS = UN seul contexte global persistant, ré-évalué par copie et par frame** : un `const`/`let` top-level lève `Identifier '...' has already been declared` à la 2e évaluation (et inonde la sortie). Écrire des expressions SANS déclaration (ternaire nu) ou `var`.

### 2.6 Utilitaires adjacents
`extractSubMeshes` (extraire un niveau en shapes), `countSubMeshes` (double = nombre d'éléments), `getSubMeshTransform`, `subMeshBoundingBox` (+ `applyDistribution`), `blendSubMeshPositions`, `contoursToSubMeshes` (multi-contour -> child-meshes), `subMeshDistribution` (Distribution Type d'un duplicator).

### 2.7 Gotchas sub-mesh
- `levels` ignoré si `levelMode != 0` (les modes 1-3 l'écrasent).
- Rien ne bouge sur une shape à contour unique (un `ellipse` n'a pas d'arbre de child-meshes) : grouper, `contoursToSubMeshes`, ou `mode:1` (Polygons).
- Profondeur SVG variable : ne pas présumer (1,1).
- `useIndex` (déf. true) dans un Duplicator : l'index du duplicator s'accumule dans l'index par caractère ; mettre false pour l'indexation indépendante.
- `shapeVisibility` false : l'élément est sauté entièrement (pas de masquage partiel, pas de position/rotation/scale/opacity).
- Replace Fill : `material` (ou `stroke`) = entrée ; `fillReplacementMode` à régler explicitement si la shape a déjà un fill.
- Sub-Mesh n'a pas d'équivalent à `useLevels` : son `levelMode` est toujours actif.

---

## 3. COLOUR AND SHADING

### 3.1 Scene Palette pour couleurs partagées
2+ shapes de même couleur -> UN swatch dans la Scene Palette (un `colorArray` par scène), connecté à chacune. Une seule shape -> set direct OK.
```js
const palette = api.getScenePalette();                        // id du colorArray
const brandRed = api.addSceneSwatch("#ff2266", "Brand Red");  // retourne l'index
for (const shape of brandedShapes) {
  api.setFill(shape, true);                                   // aussi hasFill / setStroke / hasStroke
  api.connect(palette, "array." + brandRed, shape, "material.materialColor");
}
api.set(palette, { ["array." + brandRed]: "#aa1144" });       // met à jour toutes les shapes connectées
// api.removeSceneSwatch(index)
```

### 3.2 Fill vs stroke vs gradient
Fill et stroke prennent des connexions shader **séparées**.

| Cible | Connecter shader `out` -> | Hex direct via |
|---|---|---|
| Fill | `<shape>.material.colorShaders` | `material.materialColor` |
| Stroke plat | `<shape>.stroke.colorShaders` | `stroke.strokeColor` (après `stroke.colorMode: 0`) |
| Stroke gradient | `<shape>.stroke.colorShaders` | `stroke.colorMode: 1` puis `setGradientFromColors`/`setGradientFromPalette` sur `stroke.gradient` |

- Les stops de `gradientShader` vivent dans son sub-UI `generator` (défaut `linearGradientShader`) : `setGradientFromColors(grad, "generator.gradient", [...])`, `api.set(grad, {"generator.rotation": 45})`. Swap : `api.setGenerator(grad, "generator", "<linearGradientShader|radialGradientShader|sweepGradientShader|shapeGradientShader>")`.
- **Lueurs/fonds atmosphériques douces** : `multiPointGradientShader` (pas radial + feather). `api.addArrayIndex(grad, "point")`, puis `point.<i>.pointPosition` et `point.<i>.pointColor`.

### 3.3 blendMode : shape vs shader
- `shape.blendMode` : compose toute la shape contre les calques dessous (plus large : Color, Hue, Saturation, Luminosity). Défaut pour "multiply/screen".
- `gradientShader.blendMode` : compose la sortie du shader DANS le fill, contre le reste de la pile material (quand plusieurs shaders sur `material.colorShaders`).
- **Enums non contigus et différents** (shape : 19 valeurs jusqu'à 32 avec trous ; gradientShader : sous-ensemble jusqu'à 28). Se fier aux entiers de `get_layer_definition` (`<valeur>:<nom>`), pas à un index. Multiply sur shape : `api.set(id, { blendMode: 24 })`.

---

## 4. PALETTES (3 niveaux)

| Niveau | Stockage | Usage |
|---|---|---|
| Scene | `colorArray` dans le `.cv` | swatches de la scène, undoable |
| Project | `.pal`/`.ase`/`.theme` dans le dossier Palettes du projet | marque réutilisée dans un projet |
| Library | idem dans `<appData>/Palettes` | palettes perso cross-projets |

| Opération | Scene | Library / Project |
|---|---|---|
| Lire | `getScenePalette()` | `listPalettes()`, `getPalette(name, scope?)` |
| Ajouter swatch | `addSceneSwatch(color, name?)` | `addSwatchToPalette(name, color, swatchName?, scope?)` |
| Retirer | `removeSceneSwatch(index)` | `removeSwatchFromPalette(name, indexOrUid, scope?)` |
| Créer | déjà existante | `createPalette(name, scope, swatches?, metadata?)` |
| Supprimer | boucle de remove | `deletePalette(name, scope)` |
| Importer | n/a | `importPalette(path, scope)` |
| Chercher | n/a | `lookupColor(query, options?)` |
| Vers colorArray | `getScenePalette()` en est un | `createColorArrayFromPalette(name, scope?)` |
| Gradient | `setGradientFromColors(layerId, attrId, hexes)` | `setGradientFromPalette(layerId, attrId, name, scope?)` |
| Harmonies | n/a | `generateHarmoniousPalette(baseColor, count, type, options?)` |

`scope` = `"library"` | `"project"`. En lecture, omis = library puis project. `createPalette`, `importPalette`, `deletePalette` EXIGENT `scope` explicite.

Recettes :
```js
const pal = api.getPalette("Cavalry");   // {name,scope,path,author,website,version,swatches:[{name,hex,uid}]} ou null
if (!pal) throw new Error("palette introuvable");
api.set(rectId, { "shapeMaterial.materialColor": pal.swatches[0].hex });
api.lookupColor("brand red");                                          // [{paletteName,swatchName,hex}]
api.lookupColor("Accent Red (Cavalry)", { qualified: true });          // forme qualifiée stricte

const greens = api.generateHarmoniousPalette("green", 5, "analogous");
api.createPalette("Spring Greens", "project", greens, { author: "Studio Foo" });
const arrId = api.createColorArrayFromPalette("Spring Greens", "project");
api.connect(arrId, "out", duplicator, "duplicateColor");

api.importPalette("/path/brand.ase", "project");   // .pal, .ase (lecture seule), .theme ; nom = nom embarqué ou stem du fichier
api.setGradientFromPalette(rectId, "shapeMaterial.gradient.gradientColors", "Spring Greens", "project");
const uid = api.addSwatchToPalette("Spring Greens", "#0a3d0a", "deepest", "project");
api.removeSwatchFromPalette("Spring Greens", { uid }, "project"); // ou index 0
```
- `generateHarmoniousPalette` `type` : `monochromatic`, `analogous`, `complementary`, `splitComplementary`, `triadic`, `square`, `rectangular`, `circular`, `goldenRatio` ; `options.colorSpace` "RGB" (déf.) | "LAB" ; `options.harmonic:true`. `count` clampé silencieusement (6 Triadic/SplitComplementary, 20 GoldenRatio/Circular, 8 sinon).
- `add/removeSwatch*` ne modifient que les `.pal` (`.ase`/`.theme` en lecture seule) : importer -> muter le `.pal`.
- Couleur ponctuelle : `api.set(id, { materialColor: "#ff2266" })` ou nom CSS (`"red"`) suffit.

**Lacunes connues** : la syntaxe `(PaletteName)` ne marche PAS dans `api.set` (résoudre avec `lookupColor(..., {qualified:true})` puis passer le hex) ; pas d'export ASE ; `.aco`/`.act` non supportés. Découverte : `search_api palette|swatch`, `get_api_function getPalette`.

---

## 5. COMPOUND GRAPHS

Éditeur de courbe bézier (`x∈[0,1] -> y∈[0,1]`) sur l'attribut `graph` de : `stagger`, `squetch`, `flare`, `rigControl`, `skinning`, `displacementUtility`, `materialSampler`, famille Number Range (nom d'attr possible différent : `api.getAttributes(id)`).

```js
api.graphPreset(layerId, "graph", presetIndex);
api.flipGraph(layerId, "graph", "horizontal"); // miroir gauche<->droite
api.flipGraph(layerId, "graph", "vertical");   // inversion haut<->bas
```
Préférer `flipGraph` à une réécriture (garde les poignées bézier).

`stagger` lit le graphe à `x = index/(count-1)`, remappe y dans `[minimum, maximum]`, x `strength`, + `offset`. x=0 = 1er duplicata, x=1 = dernier.

| Idx | Nom | Forme | Usage |
|--:|---|---|---|
| 0 | S-Curve | ease in/out 0->1 | fall-off naturel (défaut) |
| 1 | Ramp | 0->1 fin plus raide | **cascade gauche->droite** |
| 2 | Linear | 0->1 droit | progression uniforme |
| 3 | Flat | constante 0.5 | neutraliser |
| 4 | S-Curve flipped H | 1->0 | cascade inversée |
| 5 | Bulge | pic au début | squetch swell |
| 6 | Sideways D Bulge | 0.5 + bosse | flare highlight |
| 7 | Bell | pic au centre | **pulse centre vers l'extérieur** |
| 8 | S-Curve mirrored | 1->0 bézier | inversion |
| 9 | Flat top | constante 1.0 | pleine force partout |
| 10 | Linear inverted | 1->0 droit | linéaire inversé |

```js
const stagger = api.create("stagger");
api.graphPreset(stagger, "graph", 1);                    // Ramp
api.connect(stagger, "out", duplicator, "shapeTimeOffset");
api.set(stagger, { minimum: 0, maximum: 30 });           // 30 frames d'étalement
api.flipGraph(stagger, "graph", "horizontal");           // droite->gauche (ou preset 10 / 4)
api.graphPreset(stagger, "graph", 7);                    // Bell : centre-out
```
`valueArray` seulement pour des valeurs vraiment irrégulières (ex. `[3,1,4,1,5,9]`) ; jamais pour une progression monotone/symétrique/adoucie. Si la courbe va "dans le mauvais sens" : `flipGraph`, pas un Value Array. Presets 5 et 7 = formes canoniques de `squetch` ; 6 = natif de `flare`.

---

## 6. SEAMLESS LOOPS

- **La dernière frame rendue ne doit pas dupliquer la première** : boucle de N frames -> `endFrame = N - 1` (200 frames = 0..199 ; la frame 200 EST la 0).
- Mouvement procédural : nombre ENTIER de cycles sur la durée. `oscillator.frequency` = **taux** (cycles/seconde en `timeMode` 0 Seconds ; cycles/minute en `timeMode` 1 BPM). `numberOfWaves` = répartition SPATIALE, sans rapport avec le temps.
- Démarrer au repos : un sine brut est au milieu (vitesse max) à t=0 -> décaler la phase pour partir d'un point d'inversion.
- Bruit : `simplexNoise` a `looping` + `loopLength` natifs (exact) ; ne pas truquer.
- Dynamiques/simulations qui se stabilisent ne peuvent pas boucler seules (repos != départ) : astuce = rewind keyframé.

Vérification : **`api.setFrame` clampe silencieusement à la plage du comp** (`setFrame(endFrame+1)` renvoie les valeurs à `endFrame`, sans erreur, ce qui ressemble à "bloqué"). Élargir temporairement :
```js
const comp = api.getActiveComp();
const N = api.get(comp, "endFrame") + 1;
api.set(comp, { endFrame: N });
api.setFrame(0);  const a = api.get(id, "position.x");
api.setFrame(N);  const b = api.get(id, "position.x");
api.set(comp, { endFrame: N - 1 });          // restaurer
console.log(a, b, Math.abs(a - b) < 1e-6 ? "loops" : "SEAM");
```
Contrôle visuel : `snapshot_layer` avec l'argument `frame` (frame 0 et dernière frame in-range).

---

## 7. WAVY PATHS / `api.setEditablePath`

Schéma (PAS celui de `cavalry.Path.toObject()` qui renvoie un `polyMesh` `{meshes:[{path:[...]}]}` et échoue silencieusement ici : chemin vide) :
```js
api.setEditablePath(shapeId, false /*worldSpace*/, [
  { isClosed: false, points: [
      { position: {x:0,y:0}, inHandle: {x:..,y:..}, outHandle: {x:..,y:..}, weightLocked: false, angleLocked: false },
      { position: {x:100,y:0} }
  ] }
]);
```
- Un élément de tableau par contour. `position` requis ; `inHandle`/`outHandle` optionnels et en coordonnées **ABSOLUES** (pas des offsets). Utiliser des objets `{x,y}`, jamais des arrays `[x,y]` (le parseur abandonne au 1er point malformé).
- `worldSpace: false` presque toujours.

Sinus qui marche : échantillonner + poignées sur la **tangente** à ~1/3 du segment. Échecs connus : 2 points + poignées (droite/arche), beaucoup de points sans poignées (zigzag), longues poignées horizontales (auto-intersections en boucles).
```js
function sineWave({ length=800, amplitude=60, cycles=4, samples=64, handleFrac=1/3 }) {
  const dx = length/(samples-1), k = (cycles*2*Math.PI)/length, points = [];
  for (let i=0;i<samples;++i){
    const x=i*dx, y=amplitude*Math.sin(k*x), dy=amplitude*k*Math.cos(k*x);
    const len=Math.hypot(1,dy), tx=1/len, ty=dy/len, h=handleFrac*dx;
    points.push({ position:{x,y}, inHandle:{x:x-tx*h,y:y-ty*h}, outHandle:{x:x+tx*h,y:y+ty*h} });
  }
  return [{ isClosed:false, points }];
}
const line = api.create("editableShape","sine");
api.setEditablePath(line, false, sineWave({ length:1200, amplitude:80, cycles:5 }));
api.setStroke(line, true); api.setFill(line, false);
```
`handleFrac` : petit = plus plat aux échantillons ; grand = plus courbé, risque d'overlap au-delà de ~0.5.

Zigzag : points sans poignées, `y = ±amplitude` en alternance, `samples = cycles*2+1`. Zigzag lissé : mêmes points + deformer `bevel` (pas de poignées à la main).

Formes fermées (blobs, feuilles) : `isClosed:true`, rayon `r(θ)=base+amp*sin(cycles*θ)`, position `(r cosθ, r sinθ)`, tangente depuis `dr/dθ` et `r` (poignées en polaire).

Ne PAS scripter le chemin : vagues procédurales sur shapes existantes (deformer `oscillator`, hint motion-graphics-elements : meilleur pour animation/tweaks) ; tracés illustratifs one-shot (demander à l'utilisateur de dessiner). Le JS est pour du généré (data, échantillonné, calculé). Découverte : `search_api editablePath` (`getEditablePath`, `setEditablePath`, `createEditable`, `makeEditable`).

---

## 8. DATA VISUALISATION

### 8.1 Import de données
- CSV/Excel/Google Sheets : importer comme Asset, `addAssetToComp` crée un calque **Spreadsheet** ; brancher son `out` où nécessaire ; il sait remapper les plages numériques.
- **Colonne = index numérique 0-based, pas un titre** (malgré "Column Title" dans doc/UI). `getDropdownNiceName` renvoie des chaînes vides -> compter soi-même (`rowCount`/`columnCount` sont renvoyés par le Spreadsheet).
- **`api.writeToFile` ne crée PAS les dossiers parents** : retourne `false` sans exception. Séquence : `api.makeFolder(dir, true)` -> `api.writeToFile(dir + "/data.csv", text, true)` -> `addAssetToComp`.
- `spreadsheetLookup` (clé -> valeurs d'une autre feuille, ex. code région -> couleur) n'indexe que des feuilles **Excel** (`excelSheet`) : un CSV n'a pas de 2e feuille, donc une table de lookup exige un `.xlsx`.

### 8.2 Types de graphiques

| Graphique | Construction |
|---|---|
| Bar chart | Duplicator d'un rectangle ; hauteur pilotée par la donnée ; deformer `align` pour croître depuis le bas |
| Pie / Donut | Rectangle Pattern Shape avec générateur `ringRectPatternGenerator` |
| Line / Area | Duplicator en distribution linéaire, Spreadsheet -> `shapePosition.Y` ; `pointsToCurve` avec Point Source = distribution SubMesh, `duplicator.id` branché sur l'entrée de la distribution submesh |
| Bubble / Scatter | Duplicator distribution Point + Value sur Shape Position, source de données sur la Value |
| Stacked bar | Rectangle Pattern Shape dans un Duplicator |
| Heatmap | Duplicator en grille de Rectangles |
| Réseau / node-link | **`connectShape` est purement géométrique** (`targetMode` : Within Range / Nearest / Point Index ; pas de mode attribut/prédicat). Pour "relier ce qui partage une région", calculer les paires en script et construire les liens |

### 8.3 Animation décalée (idiome)
Ne pas keyframer chaque rectangle. Keyframer UNE fois `generator.dimensions.y` du rectangle (spring : `api.magicEasing(rectId, "generator.dimensions.y", frame, "SpringOut")`), puis un `stagger` dont `out` -> `shapeTimeOffset` du Duplicator. Min/Max du Stagger = délai entre départs. Direction/forme via compound graph (section 5, preset 1 = gauche->droite).

---

## PIÈGES FRÉQUENTS (consolidé)

Texte
1. `position` ancre la boîte, pas les glyphes : `autoWidth/autoHeight` + grosse `textBoxSize` décale tout. Fix : `textBoxSize:[1,1]` avec auto on, ou compenser via `getBoundingBox` après mise en forme finale.
2. `autoWidth` off = wrap involontaire.
3. Ne pas dessiner de carte derrière un texte : `backgroundMode` + `backgroundPadding` + `cornerRadius`.
4. `autoAnimate.progress` a 2 keyframes par défaut (f0:0, f24:100) : les supprimer avant d'écrire les siens. `progress` 0 = hors scène, 100 = repos.
5. `autoAnimate` sans `useLevels:true` = pas de granularité mot/ligne/caractère.
6. `textPath` + `autoAnimate` position = conflit. Runway : prolonger la géométrie du chemin, pas `pathTravel`. `pathTravel` non clampé ; ne pas le sonder avec `api.set`.
7. `apply*` : `mode` ET `indexMode` requis (sinon no-op).
8. `applyTypeface` : `font.font` (famille), `font.style`.
9. `manipulators` exige `stringManipulator` et remplace le texte de base ; opérateur choisi via `setGenerator`, attributs en `generator.<attr>`.
10. `indexMode` diffère : `shuffleString` (0 Word, 1 Line, 2 Paragraph, 3 Document) vs `resizeString` (0 Character, 1 Word, 2 Line, 3 Paragraph).
11. `cavalry.getFontFamilies()` / `cavalry.measureText()` : sur `cavalry`, pas `api`.
12. Glyph grid dans un duplicator : relier `duplicator.indexContext` -> `random.seed`, sinon tous les glyphes identiques ; ajouter `align` pour recentrer.
13. Typewriter : `horizontalAlignment:0` pour que le layout ne saute pas.

Sub-Mesh
14. `levels` ignoré si `levelMode != 0`. Un SVG a une profondeur variable : inspecter.
15. Shape à contour unique : rien ne bouge (grouper, `contoursToSubMeshes`, ou `mode:1`).
16. `useIndex` dans un Duplicator accumule l'index externe : mettre false pour l'isoler.
17. `shapeVisibility` false = élément ignoré complètement.
18. Expressions `javaScript` : contexte global persistant, JAMAIS de `const`/`let` top-level (utiliser ternaire nu ou `var`).
19. Replace Fill : régler `fillReplacementMode` explicitement.

Couleur / palettes
20. Fill et stroke : shaders séparés (`material.colorShaders` vs `stroke.colorShaders`) ; stroke gradient exige `stroke.colorMode:1`.
21. Stops de gradient dans `generator.gradient`, pas sur l'hôte.
22. Lueurs douces : `multiPointGradientShader`, pas radial + feather.
23. Enums `blendMode` non contigus et différents shape vs shader : lire `get_layer_definition` (Multiply shape = 24).
24. Couleur partagée par 2+ shapes : swatch Scene Palette connecté, pas N hex.
25. `(PaletteName)` ne marche pas dans `api.set` : `lookupColor` puis hex.
26. `createPalette`/`importPalette`/`deletePalette` : `scope` obligatoire ; `.ase`/`.theme` en lecture seule ; `generateHarmoniousPalette` clampe `count` sans erreur.

Compound graphs
27. Ne pas utiliser `valueArray` pour une courbe : `graphPreset` + `flipGraph`. Stagger lit x=index/(count-1).

Boucles
28. `endFrame = N-1`. Nombre entier de cycles ; `frequency` = taux (s ou BPM), `numberOfWaves` = spatial. `simplexNoise.looping`+`loopLength`.
29. `api.setFrame` clampe en silence : élargir `endFrame` pour vérifier, puis restaurer.

Paths
30. Points en `{x,y}`, handles ABSOLUS, schéma != `cavalry.Path.toObject()` (échec silencieux = chemin vide).
31. Sinus : échantillons + poignées tangentes ~1/3 de segment ; jamais deux points + poignées, ni poignées horizontales longues.
32. Vagues animées : deformer `oscillator`, pas de path scripté.

Data
33. Colonnes Spreadsheet = index 0-based. `writeToFile` ne crée pas de dossiers (`makeFolder` d'abord). `spreadsheetLookup` = Excel seulement. `connectShape` = géométrique seulement.
34. Stagger sur duplicator : 1 keyframe sur la shape + `stagger.out` -> `shapeTimeOffset`, jamais N keyframes manuels.
