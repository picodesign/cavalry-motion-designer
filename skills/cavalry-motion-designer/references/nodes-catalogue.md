# Catalogue des nodes Cavalry

Sources : scenery.io/nodes (liste complète), `search_layer_types` du MCP cavalry (nodeTypes vérifiés, 28 oct. 2026). Les nodeTypes ci-dessous sont utilisables tels quels avec `api.create("nodeType", "Nom")`. Pour la liste exhaustive des attributs d'un node : `get_layer_definition(nodeType)` avant d'écrire du code.

Conventions
- Format : `nodeType` — rôle. *Quand* : usage motion. `attrs` : attributs clés.
- ✔ = nodeType et attributs vérifiés via `get_layer_definition` (28 oct. 2026). Sans ✔ : nodeType confirmé par `search_layer_types`, mais attributs non détaillés, à vérifier avant `api.set`.
- Sub-UI : les slots `generator`, `material`, `stroke` s'adressent par chemin pointé (`generator.count`, `material.materialColor`, `stroke.width`). Faire `api.getAttributes(id)` après création.
- Nodes marqués BETA (spring, particleEmitter...) : créer et tester avant de bâtir dessus.
- Attention aux valeurs par défaut : `strengthToZero = true` sur les behaviours (oscillator, noise...) fait tendre vers 0 ; le mettre à `false` pour piloter scale/radius/opacité.
- Les nodes préfixés `sceneGroup::` sont des filtres tiers : le préfixe fait partie du nodeType.
- Les compositions se créent avec `api.createComp()` (pas via `api.create`). `compositionReference` n'apparaît pas dans `search_layer_types` : ne pas l'instancier directement.
- Types non listés ici = cachés/dépréciés/legacy (circleShape, gaussianBlurFilter sans préfixe, morphLegacy, oscillatorLegacy, soundLegacy, applyTextFill...). Ne pas les utiliser.
- Les Behaviours/Deformers/Falloffs se connectent à un shape/duplicator (`api.connect` ou onglet Behaviours) ; les atomics (Math, Value...) servent à piloter des attributs.

---

## 1. Shapes

### 1.1 Primitives (famille `basicShape`)
`basicShape` ✔ — Layer-shape dont le type de primitive se choisit via le slot `generator` (défaut : `polygonShape`). *Quand* : par défaut pour tout rectangle, ellipse, polygone, étoile. `attrs` : `generator` (sub-UI, accepte les `primitive`), `position`, `scale`, `rotation`, `pivot`, `opacity`, `material` (Fill, défaut `colorMaterial`), `stroke`, `deformers`, `filters`, `masks`, `trackMattes`, `blendMode`. Les attributs de la primitive s'adressent en `generator.<attr>` (ex. `generator.dimensions`). Alternatives directes (nodeType primitive autonome) ci-dessous ; `api.primitive("rectangle", "nom")` crée un basicShape configuré.
- `rectangleShape` ✔ — Rectangle. *Quand* : cartons, barres, masques, fonds, cards. `attrs` : `dimensions` (double2, PAS `size`), `cornerRadius`, `radiusMode` (0 All, 1 Individual), `radiusTop` / `radiusBottom` (double2, mode Individual), `chamfer`, `divisions`, `edgeDivisions`, `vectorize`.
- `ellipseShape` ✔ — Ellipse / cercle. *Quand* : points, loaders, bulles. `attrs` : `radius` (double2 x/y, PAS `size`), `semicircle`, `bezier`, `divisions`.
- `polygonShape` ✔ — Polygone régulier. *Quand* : triangles, hexagones, icônes géométriques. `attrs` : `sides` (min 3, défaut 5), `radius` (double2), `divisions`.
- `starShape` ✔ — Étoile. *Quand* : sparkles, badges. `attrs` : `sides` (nombre de branches, PAS `points`), `radius` (extérieur, PAS `outerRadius`), `innerRadius` (actif seulement si `useInnerRadius` = true), `useIndividualRadii`, `divisions`.
- `ringShape` ✔ — Anneau. *Quand* : loaders, ondes, cibles. `attrs` : `radius` (rayon extérieur), `width` (= rayon intérieur, label "Inner Radius", PAS `thickness`), `divisions`.
- `arcShape` ✔ — Arc / portion d'anneau. *Quand* : jauges, camemberts, progress circulaire. `attrs` : `startAngle` (défaut 90), `endAngle` (défaut 270), `radius` (extérieur), `width` (rayon intérieur), `bezier`, `divisions`.
- `capsuleShape` ✔ — Capsule / pill. *Quand* : boutons, tags, barres arrondies. `attrs` : `length`, `radius` (double2), `drawMode` (0 Length, 1 Start/End), `start`/`end` (mode Start/End), `trimEnds`, PAS `size`.
- `superEllipseShape` ✔ — Squircle. *Quand* : icônes d'app, cards "iOS". `attrs` : `push` (courbure, défaut 0.5, PAS `exponent`), `radius`.
- `superShape` ✔ — Superformule. *Quand* : formes organiques, fleurs, motifs. `attrs` : `a`, `b`, `n1`, `n2`, `n3` (PAS `m`), `complexity`, `radius`.
- `arrowShape` ✔ — Flèche paramétrique. *Quand* : indicateurs, infographies. `attrs` : `bodyLength`, `bodyWidth`, `generateFirstHead` (sub-UI `arrowHead`, défaut `basicArrowHead`, extrémité +X), `generateSecondHead` (extrémité -X, vide = bout plat). Têtes : Basic, Chevron, Barbed, Circle, Box.
- `cogwheelShape` ✔ — Engrenage. *Quand* : icônes techniques, mécanismes. `attrs` : `teeth` (min 3, défaut 12), `radius` (Pitch Radius), `radiusHole`, `thickness` (Tooth Depth), `toothThickness` (Tooth Width), `taper` (double2), `midpointPosition`.

### 1.2 Lignes (famille `basicLine`)
`basicLine` ✔ — Ligne générique (Line, Spiral, Bézier). *Quand* : traits animés, underlines, connecteurs. `attrs` : `generator` (sub-UI `lineGenerator`, défaut `simpleLine`), `stroke` (défaut `strokeMaterial`, une ligne se voit par son stroke), `material`. Longueur : `generator.length`.
- `simpleLine` ✔ — Segment droit (générateur de `basicLine`). `attrs` : `length` (défaut 200), `divisions` (défaut 10).
- `spiralLine` — Spirale. *Quand* : hypnotique, loaders, ornements.
- `bezierLine` — Courbe Bézier à 4 points. *Quand* : arcs fluides, trajectoires décoratives.
- `rayLine` — Rayon infini coupé par collisions. *Quand* : lasers, lumière, scanners.

### 1.3 Géométrie dérivée
- `editableShape` — Shape dont les points s'éditent (Pen/Shape tool, `api.set` de points). *Quand* : logos tracés à la main, paths custom, import d'un tracé. `attrs` : `editMode`, `path`.
- `svgShape` ✔ — SVG importé converti en shapes (sub-meshes). *Quand* : logos fournis en SVG (préférer à un import AI/PNG). `attrs` : `input` (assetId, label "File", PAS `asset`), `useMaterials` (couleurs du SVG), `useStrokes`.
- `customShape` — Utilise la géométrie d'un autre layer (référence). *Quand* : réutiliser un logo sans le dupliquer. `attrs` : `shape` (connexion).
- `textShape` — Texte riche (voir section Text).
- `imageToShapes` — Échantillonne une image en shapes. *Quand* : pixel art, mosaïques, halftone vectoriel. `attrs` : `asset`, `resolution`.
- `isolinesShape` — Courbes de niveau depuis image/shape. *Quand* : topographie, fonds graphiques généreux. `attrs` : `levels`.
- `metaballs` — Fusionne des shapes en blobs. *Quand* : effet goo, liquides. `attrs` : `threshold`, `smoothing`.
- `outline` — Crée un contour comme shape. *Quand* : stroke convertible, double contours. `attrs` : `width`.
- `extrude` — Profondeur apparente 2.5D. *Quand* : logos en relief, texte 3D light. `attrs` : `depth`, `angle`.
- `trails` — Lignes générées par le mouvement d'un shape. *Quand* : traînées, signatures de mouvement. `attrs` : `length`.
- `convexHull` — Enveloppe convexe d'autres shapes. *Quand* : fond qui enveloppe un groupe.
- `mergeShape` — Joint deux paths ouverts en un fermé. *Quand* : fermer des contours.
- `segmentPath` — Découpe des paths en segments. *Quand* : animer chaque segment indépendamment.
- `pointsToCurve` — Path depuis points d'une distribution. *Quand* : courbes organiques à partir de points random.
- `connectShape` — Relie les points d'une distribution en lignes. *Quand* : constellations, réseaux. `attrs` : `maxDistance`.
- `shortestPath` — Chemin entre départ et arrivée. *Quand* : tracés intelligents, circuits.
- `quadTreeShape` — Subdivise un carré selon la densité de points. *Quand* : motifs génératifs.
- `rectPatternShape` — Barres / camemberts / anneaux / codes-barres. *Quand* : data-viz, graphiques animés. `attrs` : `values`.
- `extractSubMeshes` — Extrait des sub-meshes. *Quand* : isoler lettres/pièces d'un shape complexe.
- `subBoundingBox` — Rectangles des bounding boxes de sub-meshes. *Quand* : surligneurs de mots, backgrounds de texte.
- `meshShape` — Warp d'images/shaders avec le Mesh Tool. *Quand* : drapeaux, déformation d'image.
- `cornerPinShape` — Perspective 4 coins. *Quand* : mockups écran, packshots en perspective.
- `celAnimationShape` — Animation image par image. *Quand* : animation traditionnelle.
- `javaScriptShape` — Shape générée par JS. *Quand* : géométrie procédurale sur mesure.
- `backgroundShape` — Rectangle calé sur la résolution de la comp. *Quand* : fond plein de toute scène (à créer en premier). `attrs` : couleur via `material.materialColor`. (Existe aussi comme attribut `backgroundShape` de `textShape`/`layoutGroup` : fond derrière le texte/layout.)
- `contoursToSubMeshes` (behaviour, Cavalry 2.3+) — Convertit les contours d'un path en sub-meshes. *Quand* : animer chaque contour d'un logo/path séparément (Sub-Mesh, Duplicator).
- `spacerItem` — Espace vide dans un layout.

### 1.4 Containers et layout
- `group` — Dossier + transform partagé (super: `shape`). *Quand* : regrouper pour animer ensemble. `attrs` : `position`, `opacity`, `filters`, `masks`.
- `component` — Group réutilisable (instances, éléments exposés). *Quand* : templates, variantes de formats.
- `layoutGroup` ✔ — Layout auto horizontal/vertical. *Quand* : boutons, listes, menus. `attrs` : `direction` (0 Horizontal, 1 Vertical), `spacing` (int, PAS `gap`), `margins` (int4, PAS `padding`), `spacingMode` (0 Manual Spacers, 1 Flex Start, 2 Flex End, 3 Centre, 4 Space Between, 5 Space Around, 6 Space Evenly), `wrapMode` (0 No Wrap, 1 Wrap, 2 Wrap Reverse), `lineSpacing`, `alignContent`, `orderingPolicy` (0 Layer Order, 1 Alphabetical, 2 Shuffle), `flipOrder`, `minimumSize`, `maximumSize`. Les enfants règlent `horizontalLayoutAlignment` / `verticalLayoutAlignment` et `excludeFromLayout`. Types liés : `horizontalLayout`, `verticalLayout`, `gridLayout` (super `layoutItem`).
- `gridLayoutGroup` / `gridLayoutRow` — Layout en grille avec lignes. *Quand* : grilles produits, dashboards.
- `duplicator` ✔ — Clone et distribue des shapes. *Quand* : tout motif répété, grilles, textes lettre par lettre. `attrs` : `shapes` (liste d'Input Shapes, plusieurs = alternance par index), `generator` (sub-UI distribution, défaut `gridDistribution` ; PAS `distribution`/`count` à la racine : `generator.count`, `generator.size`...), `shapePosition`, `shapeRotation`, `shapeScale`, `shapeSkew`, `shapeOpacity`, `shapeVisibility`, `shapeTimeOffset` (y brancher un `stagger`), `shapeId` + `autoId` (choix aléatoire de l'input), `indexContext`, `useIndex`, `skipInvisibleDuplicates`. Changer de distribution : `api.setGenerator(dupId, "generator", "<distributionType>")`.
- `forgeDynamicsShape` — Physique 2D rigide. *Quand* : objets qui tombent/rebondissent. `attrs` : `gravity`.
- `particleShape` — Particules (voir section Particles).

### 1.5 Matériaux (fill/stroke multi-shapes)
- `colorMaterial` ✔ (Fill) — Fill appliqué à plusieurs shapes. *Quand* : une couleur de marque partagée. `attrs` : `materialColor` (PAS `color`, qui est le label), `alpha` (0-100), `colorShaders` (liste de shaders).
- `strokeMaterial` ✔ (Stroke) — Stroke partagé. `attrs` : `strokeColor` (PAS `color`), `width` (défaut 4), `alpha`, `trim` (bool, DOIT être true pour activer), `trimStart` / `trimEnd` (pourcentage 0-100, défaut 0-100), `trimTravel`, `capStyle` (0 Flat, 1 Round, 2 Projecting), `joinStyle` (0 Mitre, 1 Round, 2 Bevel), `align` (0 Centre, 1 Inner, 2 Outer), `dashPattern` (string), `dashOffset`, `colorMode` (0 Single Color, 1 Gradient), `taperedWidth` / `widthGraph`, `startWidth` / `endWidth` / `doubleTaper`.
- `strokeDuplicator` — Combinaisons complexes de strokes. *Quand* : contours multiples, effets néon.

> Sur un shape normal, `fill` et `stroke` sont des sub-UI directs (ex. `material.materialColor`, `stroke.width`, `stroke.trimEnd`). Les `*Material` servent à partager. `basicLine` crée un `strokeMaterial` par défaut ; `basicShape`, `textShape`, `svgShape` un `colorMaterial`.

---

## 2. Generators / Distributions

Se choisissent dans le slot `duplicator.generator` (`api.setGenerator(dupId, "generator", "<type>")`). Tous de super-type `distribution`. Attributs adressés en `generator.<attr>`. Les attributs d'une distribution sont évalués PAR POINT (on peut y brancher un behaviour indexé). Pas de `spacing` : `size` = étendue TOTALE, pas = `size / (count - 1)`.
- `linearDistribution` ✔ — Ligne régulière. *Quand* : rangées, séquences, barres. `attrs` : `count` (défaut 3), `size` (longueur totale, PAS `length`), `direction` (0 Horizontal, 1 Vertical ; PAS `angle`), `distributionMode` (0 Fit, 1 Step : en Step `size` = espacement).
- `gridDistribution` ✔ — Grille 2D. *Quand* : motifs, grilles de logos. `attrs` : `count` (int2 [x,y], PAS `countX/Y`), `size` (double2, étendue totale, PAS `spacing`), `distributionMode` (0 Fit, 1 Step), `direction` (colonnes/lignes), `offset` (décalage une ligne sur deux).
- `circleDistribution` ✔ — Cercle. *Quand* : couronnes, horloges, mandalas. `attrs` : `count`, `radius` (défaut 200), `angle` (étendue totale, défaut 360 ; >360 = anneaux concentriques), `startAngle`, `travel` (%), `flip`, `includeEnd`, `calculateRotations` (oriente selon la tangente).
- `randomDistribution` ✔ — Positions aléatoires. *Quand* : confettis, étoiles, poussière. `attrs` : `count` (défaut 50), `seed`, `size` (zone, PAS `area`), `shapeType` (0 Rectangle, 1 Ellipse), `relaxMode` + `relaxDistance` (écartement type Poisson), `useProbability`.
- `fibonacciDistribution` — Spirale de Fibonacci. *Quand* : tournesol, motifs organiques.
- `roseDistribution` — Courbe rose. *Quand* : motifs floraux.
- `mathDistribution` — Distribution par formule. *Quand* : courbes mathématiques (Lissajous...).
- `pointDistribution` — Un point. *Quand* : base pour offsets.
- `pathDistribution` ✔ — Le long d'un path. *Quand* : objets sur une courbe, convoyeur. `attrs` : `inputShape` (connexion, PAS `path`), `count`, `mode` (0 Per Shape, 1 Per Sub-Mesh, 2 Per Contour), `travel` (%, fait défiler), `offset`, `length` (% du path), `flip`, `excludeEnd` (boucles), `calculateRotations`.
- `shapePointDistribution` — Aux points d'un shape. *Quand* : décorer les sommets d'un logo.
- `shapeEdgeDistribution` — Sur les arêtes d'un shape. *Quand* : contours peuplés.
- `meshDistribution` (Sub-Mesh) — Aux sub-meshes d'un shape. *Quand* : une copie par lettre/élément.
- `arrayDistribution` — Depuis un Array (valeurs). *Quand* : positions pilotées par données.
- `voxelizeDistribution` — Voxels d'un shape. *Quand* : pixelisation en 3D light.
- `particleDistribution` — Aux particules. *Quand* : instancier des shapes sur une sim.
- `customDistribution` — Points définis à la main/JS.
- `transformDistribution` — Transforme une distribution existante. *Quand* : décaler/pivoter un set de points.
- `maskDistribution` — Masque une distribution par un shape. *Quand* : remplir un logo de points.
- `sortDistribution` — Réordonne les index. *Quand* : changer le sens d'un stagger (centre vers extérieur).
- `shuffleDistribution` — Mélange les index. *Quand* : apparitions aléatoires.
- `applyDistribution` (behaviour) — Applique une distribution aux sub-meshes d'un shape. *Quand* : réarranger les lettres sans duplicator.
- Doc duplicator : `epicycloid` / `epitrochoid` (courbes décoratives) et `connectDistribution` (relie deux points par copie) sont cités, mais absents de `search_layer_types` : vérifier avant usage.

---

## 3. Behaviours (animation procédurale)

### 3.1 Mouvement, timing, secondaire
Attributs communs aux behaviours ✔ : `on`, `out` (polymorphe), `strength` (%), `falloffs` (liste, voir §5). Sortie = `offset + value × strength% × falloff`. Pour sommer deux signaux dans un seul attribut : les passer dans `value` (`value` + `offset`) puis connecter la sortie.
- `spring` ✔ (BETA) — Secondaire sur keyframes de position. *Quand* : overshoot/rebond organique sur un mouvement existant. `attrs` : `damping` (0.7), `mass` (1), `speedLimit` (100), `time`. PAS de `stiffness`. Pour un overshoot fiable sans spring : `api.magicEasing(..., "SpringOut")`.
- `autoAnimate` — Animation variée depuis peu de keyframes. *Quand* : variations rapides sur beaucoup d'éléments.
- `noise` ✔ — Bruit continu. *Quand* : respiration, tremblement, wiggle, déformation. `attrs` propres : `generator` (sub-UI moteur, défaut `simplexNoise`, accepte `cubicNoise`, `valueNoise`, `cellularNoise`), `strengthToZero` (défaut true), `useNormals` (déformeur : le long des normales). PAS d'`amplitude`/`frequency`/`seed` à la racine : ils sont dans le moteur, `generator.minimum` / `generator.maximum` (défaut -10/10, jouent le rôle d'amplitude), `generator.frequency`, `generator.seed`, `generator.noiseScale`, `generator.timeScale`, `generator.octaves`, `generator.looping` + `generator.loopLength` (boucle), `generator.separateChannels`, `generator.stagger`, `generator.useIndex`, `generator.usePosition`, `generator.curl`.
- `oscillator` ✔ — Ondes pour déformer/affecter. *Quand* : pulsation, balancier, ripple sur clones. `attrs` : `frequency` (cycles/s, défaut 5), `minimum` / `maximum` (défaut -10/10, PAS `amplitude`), `waveType` (0 Normal, 1 Square, 2 Triangle, 3 Sawtooth, 4 Custom), `trigType` (0 Sine, 1 Cosine, 2 Tangent), `timeMode` (0 Seconds, 1 Minutes BPM), `timeOffset`, `timeScale`, `stagger` (déphasage par clone), `offset`, `separateChannels`, `strengthToZero`, `useNormals`.
- `wave` ✔ — Ondulation de contours (déformeur). *Quand* : drapeaux, vagues, tracés ondulés. `attrs` : `mode` (0 Sine, 1 Square, 2 Sawtooth, 3 Triangle ; PAS `waveType`), `amplitude` (px, défaut 30), `numberOfWaves` (PAS `wavelength`), `travel` (animer pour faire avancer), `samplePoints`, `outputBeziers`, `adaptiveWaveCounts`.
- `stagger` ✔ — Rampe de valeurs min→max sur les index. *Quand* : cascade d'apparition (clone par clone). Brancher `out` sur `duplicator.shapeTimeOffset`. `attrs` : `minimum` (défaut 0), `maximum` (défaut 5), `offset`, `graph` (courbe de répartition). PAS de `delay`/`step` : l'écart entre deux clones = (maximum - minimum) / (count - 1).
- `frame` ✔ — Le temps pilote des attributs. *Quand* : rotation continue, compteurs. `attrs` : `value` (multiplicateur du temps, PAS `multiplier`), `offset`, `startFrame`, `mode` (0 Frame : value × frame, 1 Seconds), `cycleLength` (mode Seconds), `graph`.
- `motionStretch` — Déforme selon la vitesse. *Quand* : étirement de vitesse, motion blur stylisé.
- `squashAndStretch` — Squash/stretch avec bulge. *Quand* : rebond de balle, logo "vivant".
- `squetch` — Squash & stretch simple (volume non préservé).
- `travel` — Déplace les points de départ le long des contours. *Quand* : dessiner/animer un tracé.
- `pathfinder` — Déplace/déforme des shapes le long d'un path. *Quand* : objet suivant une trajectoire. `attrs` : `path`, `offset`.
- `lookAt` — Oriente vers une cible. *Quand* : yeux, flèches, aiguilles.
- `behaviourMixer` — Combine/contrôle plusieurs behaviours. *Quand* : fader un noise on/off.
- `schedulingGroup` (utility) — Décale des enfants dans le temps (voir Utilities).

### 3.2 Valeurs et maths pilotant des attributs
- `value` ✔ / `value2` / `value3` — Stocke/manipule 1D/2D/3D. *Quand* : contrôleur central animé qui pilote N attributs, ou porte d'un falloff. `attrs` : `value`, `offset`, `timeOffset` ; sortie = `value × strength + offset`.
- `valueBlend` / `value2Blend` / `value3Blend` — Interpole entre deux valeurs. *Quand* : switch A/B animé.
- `positionBlend` — Interpole deux positions.
- `colorBlend` — Mélange deux couleurs via gradient. *Quand* : transition de couleur pilotée.
- `numberRange` ✔ — Remappe plage A vers B. *Quand* : convertir 0-1 en 0-360° ou une position. `attrs` : `value` (entrée), `sourceMin` / `sourceMax` (défaut 0/10), `min` / `max` (sortie, défaut 0/100), `clampValues`, `offset`, `graph` (courbe d'easing).
- `numberRangeToColor` — Remappe vers un gradient.
- `random` — Nombres aléatoires avec biais. `attrs` : `seed`, `minimum`, `maximum`, `useIndex` (valeur stable par clone) (d'après la doc duplicator ; non détaillé via `get_layer_definition`).
- `modulate` — Séquences répétées (modulo).
- `round` — Arrondit (ou arrondit les coins d'un shape). *Quand* : coins arrondis sur path ou entiers.
- `distance` — Attribut piloté par la distance à un layer. *Quand* : interactions de proximité.
- `simpleValueSolver` / `simpleValue2Solver` — Mémoire des valeurs passées. *Quand* : traînées, accumulation, fade.
- `sound` — Audio pilote des valeurs. *Quand* : visualiseur audio, réaction à la musique. `attrs` : `asset`, `band`.
- `materialSampler` — Échantillonne la couleur d'un shape pour piloter. *Quand* : réactivité à une couleur.
- `getVector` — Vecteur entre deux points.
- `isWithin` — Teste si une position est dans un shape.

### 3.3 Transformations de shapes (behaviours)
- `manipulator` ✔ — Applique des transforms aux sub-meshes. *Quand* : animer des lettres/éléments individuels. `attrs` : `position` (double2), `rotation`, `scale`, `pivot`.
- `subMesh` ✔ — Accès aux sub-meshes (transform, matériaux). *Quand* : style/animation par caractère/élément. `attrs` : `levelMode` (0 Custom, 1 Text Lines, 2 Text Words, 3 Text Characters, 4 All ; PAS `level`), `levels` (int2, si Custom), `shapePosition`, `shapeRotation`, `shapeScale`, `shapeOpacity`, `shapeVisibility`, `shapeTimeOffset` (y brancher stagger/random/noise), `transformAroundCenter` (Recalculate Pivot), `pivotPosition`, `deformers`, `filters`, `fillBehaviours`/`strokeBehaviours` (overrides), `material`/`stroke` (remplacement), `indexMode`, `useIndex`, `falloffs`.
- `align` — Place le pivot aux bords de la bounding box. *Quand* : ancrer en bas/gauche avant un scale.
- `3dMatrix` — Transformations 3D sur shapes/sub-meshes. *Quand* : rotation 3D de cartes.
- `skew` — Cisaillement. *Quand* : italique, vitesse.
- `autoCrop` — Rogne selon la bounding box.
- `blendShape` — Fond un shape dans un autre (nombre de points différent). *Quand* : morph simple. `attrs` : `blend`, `shape` (connexion).
- `morph` — Morph intelligent par région. *Quand* : logo A vers logo B, icônes qui se transforment. `attrs` : `morph`.
- `blendSubMeshPositions` — Interpole les positions de sub-meshes entre deux shapes. *Quand* : lettres qui s'assemblent d'un layout à l'autre.
- `visibility` ✔ (Visibility Sequence) — Visibilité des sub-meshes. *Quand* : apparition caractère par caractère, typewriter. `attrs` : `start`, `end` (0-100 %, animer `end` de 0 à 100), `travel`, `invert`, `alwaysOn` / `alwaysOff` (indices, string).
- `boolean` — Union/soustraction/intersection. *Quand* : découper un logo, masques vectoriels.
- `chopPath` — Coupe les paths en morceaux. *Quand* : lignes pointillées/éclatées.
- `splitPathUtility` (Trim Path) — Découpe un path. *Quand* : tracé de trait partiel.
- `knot` — Gaps aux croisements. *Quand* : noeuds celtiques, entrelacs.
- `stitches` — Remplissage "couture". *Quand* : hachures, textures.
- `flattenShapeLayers` — Aplati la hiérarchie en un path. *Quand* : préparer pour Boolean/Outline.
- `rubberHoseLimb` — Membre IK 2 os. *Quand* : personnages style rubber hose.
- `meshSolver` — Boucle de deformers itératifs. *Quand* : drawing machines, effets cumulatifs.
- `voxelize` — Voxels avec gaps.
- `applyLayout` — Empile des shapes dans un sub-mesh (comme layout group).
- `countSubMeshes` (utility) — Compte les sub-meshes.

### 3.4 Matériaux par sub-mesh
- `materialBehaviourColor` — Override de couleur. *Quand* : colorer des lettres.
- `materialBehaviourAlpha` — Override d'alpha. *Quand* : fade par caractère.
- `materialBehaviourHSV` — Override hue/sat/val.
- `materialBehaviourSwapColor` — Remplace une couleur par une autre.

---

## 4. Deformers (modifient la géométrie)

Un deformer se branche dans la liste `deformers` d'un shape (ou de `subMesh`). Les noms ci-dessous sont aussi des behaviours : même nodeType.
- `noise` ✔ — Bruit sur les points (mode deformer). *Quand* : formes organiques, blobs vivants. Mêmes attrs que §3.1 (`generator.*`, `useNormals` pertinent ici).
- `wave` ✔ — Ondulation. *Quand* : drapeau, bannière. Attrs §3.1.
- `oscillator` ✔ — Ondes sur points. *Quand* : respiration d'un contour. Attrs §3.1.
- `bend` — Courbe un shape autour d'un cercle. *Quand* : texte en arc. `attrs` : `angle`.
- `bevel` — Biseaute les coins (rond ou mitre). *Quand* : adoucir des coins nets. `attrs` : `radius`.
- `round` — Arrondi des coins.
- `lattice` — Grille de points de contrôle. *Quand* : déformation libre d'un logo. `attrs` : `resolution`.
- `latticeController` (utility) — Manipule plusieurs points de lattice ensemble.
- `fourPointWarp` — Warp 4 coins avec poignées Bézier. *Quand* : perspective sommaire d'un shape.
- `pinch` — Pince/étire dans un falloff piloté par un null. *Quand* : bosse locale suivant un curseur.
- `flare` — Effile le long d'un axe. *Quand* : pointes, gouttes, queues.
- `pushAlongVector` — Pousse le long d'un vecteur. *Quand* : étirements directionnels.
- `pathOffsetBehaviour` — Grossit/rétrécit un path. *Quand* : contour offset, halos.
- `pathAverage` — Lisse en moyennant les points.
- `pathRelax` — Écarte les points entre eux.
- `resamplePath` — Simplifie/ré-échantillonne ; ferme les paths ouverts.
- `subdivide` — Divise et lisse. `addDivisions` — Ajoute des points avant déformation.
- `cleanUp` — Supprime les points inutiles.
- `curvesToLines` — Transforme les Bézier en segments (style low-poly).
- `extendOpenPaths` — Prolonge les extrémités.
- `reversePathUtility` — Inverse la direction.
- `fillRule` — Règle de remplissage (trous, auto-intersections).
- `javaScriptDeformer` — Déformation scriptée.
- `meshSolver` — Déformations itératives.
- `contoursToSubMeshes` — Contours en sub-meshes (voir §1.3).
- `skew` (behaviourBase) — cisaillement ; `flare`, `pinch`, `bend` (behaviourBase), `fourPointWarp` (behaviour) confirmés par `search_layer_types`.

---

## 5. Falloffs

Principe : un falloff sort une valeur 0..1 qui multiplie le `strength` du behaviour/deformer auquel il est connecté. `out = offset + value × strength% × falloff` (1 dans la zone, 0 hors zone).

### 5.1 `falloff` ✔ (super `drawable`, layer visible dans la scène, déplaçable/animable/parentable)
Layer-forme qui atténue behaviours, deformers et Forge fields selon la position. Sortie : 1 au centre, 0 au bord, façonnée par le graph.
- `shapeType` (enum) : 0 Circle (graph échantillonné radialement), 1 Rectangle (en x et y), 2 Linear (1 dimension), 3 Sweep (comme un gradient angulaire ; la `rotation` du falloff crée des effets radar), 4 Shape (formes custom).
- `size` (double2, défaut 200x200 ; Circle/Rectangle/Linear), `strength` (%, défaut 100), `graph` ("Falloff Graph" : axe X 0..1 centre vers extérieur, axe Y multiplicateur).
- Sweep : `angles` (double2 début/fin, défaut 0-360), `repetitions`.
- Shape : `inputShapes` (liste de shapes à connecter), `pathMode` (0 Filled Path, 1 Path Edges), `pathDistance` (px autour des formes).
- `useProbability` + `seed` : le falloff devient un tirage 0/1 (valeur 0.5 = 50 % de chance).
- `enabled` (false = sort 1, comme s'il n'existait pas), `customColor` + `drawColor`, `hidden`, plus les transform (`position`, `rotation`, `scale`, `pivot`).
- PAS d'attributs `shape`, `falloff` ni `invert` : pour inverser, courber le `graph`.

### 5.2 `rangeFalloff` ✔ (super `atomic`, pas de forme : travaille sur les INDEX de clones/lettres/mots/lignes)
- `mode` (enum) : 0 Specific Indices, 1 Percentage, 2 Transition.
- Specific Indices : `indices` (string, `0,1:3,8`, `first`, `last` ; défaut `first,last`). Sur du texte, l'espace compte comme un index.
- Percentage : `start` / `end` (défaut 25 / 75), `percentageOffset` (fait défiler / boucler), `useGraph` + `graph` (axe X = total des index).
- Transition : `transitionSize` (nombre d'index dans la fenêtre, défaut 10), `transitionCompletion` (0-100 %, à animer pour balayer).
- `indexOffset` (mode Specific), `invert`, `strength`.
- PAS d'attribut `softness` : l'adoucissement vient de `transitionSize` ou du `graph`.

### 5.3 Brancher et combiner
- Dans la liste `falloffs` du behaviour : `api.connect(falloffId, "id", behaviourId, "falloffs")`. Un behaviour peut avoir plusieurs falloffs.
- Chaque falloff a un Layer Mode (empilement de bas en haut, le premier doit être Normal) : Normal (Add), Min, Max, Minus, Multiply, Screen, Overlay. Ex. cercle (Normal) moins cercle plus petit (Minus) = anneau ; multiplier par un rectangle au graph dur = découpe.
- Un falloff peut être activé/désactivé dans le Scene Window (menu contextuel Enable/Disable Falloff).

### 5.4 Usages typiques
- Duplicator, zone mobile (porte par copie) : `value` avec le falloff dans `falloffs`, `value` = delta, `offset` = valeur de repos, sortie sur `duplicator.shapeScale` / `shapeRotation` (utiliser `value2` pour un double2). Le falloff échantillonne la position de chaque copie ; parenter le falloff à un `null` qui orbite ou traverse.
- Duplicator, par index : `rangeFalloff` en mode Transition dans un `value`/`noise` pour qu'un effet balaie les clones ; mode Percentage pour animer les clones 20 % à 60 %.
- Sub-Mesh / texte : falloff ou `rangeFalloff` dans `subMesh.falloffs`, ou dans un override (`materialBehaviourColor`, `materialBehaviourAlpha`, `materialBehaviourHSV`) pour colorer/fader les lettres dans une zone ; `applyFontSize` accepte aussi un Range Falloff.
- Deformers : falloff dans `noise` / `wave` / `pinch` / `pushAlongVector` / `lattice` pour ne déformer qu'une zone ; `pinch` se pilote par un `null` dans un falloff.
- Blend de couleur / position : falloff dans `colorBlend` ou `positionBlend` pour qu'un élément change de couleur / bouge quand la forme passe dessus.
- Interactions : `distance` (proximité d'un layer) est l'alternative sans forme.
- Pour ne pas être piégé : `strengthToZero` doit être false si le repos n'est pas 0.

### 5.5 Contextes d'index (autres sources de variation par clone)
- `contextIndex` — Envoie l'index du clone à d'autres layers. *Quand* : décaler le timing par clone (via Math).
- `velocityContext` / `velocityMagnitudeContext` — Direction / vitesse d'un clone. *Quand* : orienter ou étirer selon le mouvement.
- `lengthContext` — Longueur de path dans un sub-mesh.
- `layerSeed` — Valeur aléatoire unique par connexion. *Quand* : variations stables par layer.
- `indexToColor` — Gradient réparti sur des clones. *Quand* : arc-en-ciel sur une rangée.

---

## 6. Utilities

### 6.1 Contrôle et données
- `null` ✔ — Layer non rendu servant de contrôleur / parent. *Quand* : rigs, pivots, cibles, support d'un falloff. `attrs` : `position`, `rotation`, `scale`, `pivot`, `shape` (affichage 0 Cross, 1 Circle, 2 Square), `positionLimit` + `positionLimitMin/Max`, `rotationLimit`, `scaleLimit`.
- `rigControl` — Joystick 2D. *Quand* : rigs interactifs.
- `customDropdown` — Menu dont la valeur sélectionnée est la sortie. *Quand* : switch de variantes.
- `boundingBox` ✔ — Extrait la bounding box. *Quand* : card qui épouse son texte. `attrs` : `inputShapes` (liste), `size` (sortie), `position` (sortie, centre), `rect`, `expand` (marge ajoutée), `sampleAtFrame` + `sampleFrame`.
- `sequence` (atomic) — Séquences de nombres non répétitives, aléatoires ou non. *Quand* : ordres d'apparition aléatoires sans doublon.
- `measure` — Distance entre shapes. `radius` — rayon d'un shape. `pathLength` — longueur de path.
- `getLayerName` — Nom en string.
- `getSubMeshTransform` — Transform d'un sub-mesh.
- `localTime` — Heure/date courante.
- `secondsToFrames` — Conversion.
- `timelineCounter` — Accumule/déclenche selon markers, BPM ou secondes. *Quand* : sync musique.
- `schedulingGroup` — Place les enfants dans le temps. *Quand* : enchaîner des scènes/éléments automatiquement.
- `animationControl` — Remappe une courbe d'animation en pourcentage. *Quand* : scrubber un mouvement par une valeur.

### 6.2 Maths et logique
- `math` ✔ / `math2` — Opérations sur valeurs 1D/2D. *Quand* : décalage, multiplication, mix. `attrs` : `first`, `second`, `operation` (0 Add, 1 Subtract, 2 Multiply [défaut], 3 Divide, 4 Modulus, 5 FModulus, 6 Max, 7 Min, 8 Average, 9 Power, 10 Square Root, 11 Sine, 12 Cosine, 13 Floor, 14 Ceiling, 15 Round, 16 Absolute), `out` (Result, lecture seule).
- `jsmath` — Formule JS libre. *Quand* : expressions complexes.
- `logic` — Booléens. `comparison` — Comparaisons. `ifElse` — Choix conditionnel.
- `javaScript` — Script lié à des attributs / simulations.

### 6.3 Arrays (listes référençables par index)
- `valueArray` / `value2Array` / `value3Array` — Listes de nombres/positions.
- `colorArray` — Palette indexable. *Quand* : couleurs de marque par clone.
- `stringArray` — Liste de textes. *Quand* : textes différents par clone.
- `shapeArray` / `meshArray` — Liste de shapes. *Quand* : un clone = une forme différente.
- `shaderArray` — Liste de shaders. `assetArray` — Liste d'assets (images). `typefaceArray` / `typeface` — Liste de fontes.
- `spreadsheet` / `spreadsheetLookup` — Données CSV, lookup par clé. *Quand* : data-driven (prix, noms).
- `assetFromSmartFolder` — Asset depuis un Smart Folder.

### 6.4 Couleur
- `hsvColor` — Couleur depuis H/S/V. `colorInfo` — Lit H/S/V. `contrastingColor` — Contraste auto (texte sur fond).

### 6.5 Contraintes
- `transformConstraint` — Colle un shape à un autre (pick/put down).
- `boundingBoxConstraint` — Contraint dans une bounding box.
- `compConstraint` — Contraint aux bords de la comp. *Quand* : éléments qui restent dans le cadre.
- `componentConstraint` — Contraint aux points/arêtes d'un shape.
- `pointConstraint` / `edgeConstraint` (constraintOperator) — Contraignent un point / une arête d'un shape. *Quand* : accrocher un élément à un sommet ou une arête.

### 6.6 Strings
- `string` — Texte stocké. `stringGenerator` — Dates, heures, nombres, hashs, timecodes (compteurs). `stringManipulator` — Mélange, remplace, redimensionne. `stringLength` — Compte. `stringFromAsset` — Contenu d'un fichier texte. `regexString` — Filtrage regex. `subtitleExtractor` — Extrait des sous-titres.

---

## 7. Shaders / Effects / Filters

Les filtres s'ajoutent à un shape/group ; les shaders se branchent dans un fill ou comme source.

### 7.1 Flou
- `blurFilter` ✔ (Fast Blur) — Flou H/V indépendants. *Quand* : defocus rapide, reveals. `attrs` : `amount` (double2 [x,y], défaut 10/10, PAS `blurX`/`blurY`), `tileMode` (0 Clamp, 1 Tile, 2 Transparent), `mattes`. Attributs communs de tout filtre : `mattes`, `matteApplyMode`, `matteTileMode`.
- `sceneGroup::gaussianBlurFilter` — Gaussien haute qualité (attrs non détaillés).
- `sceneGroup::boxBlurFilter` — Box rapide.
- `sceneGroup::directionalBlurFilter` — Flou directionnel. *Quand* : motion blur stylisé, vitesse.
- `sceneGroup::zoomBlurFilter` — Flou radial. *Quand* : impact, whoosh.
- `sceneGroup::bilateralBlurFilter` — Conserve les arêtes.
- `backgroundBlurFilter` — Flou du fond via un shape. *Quand* : glassmorphism.
- `luminanceBlur` — Flou piloté par luminance d'un autre layer.

### 7.2 Lumière et ombres
- `glowFilter` ✔ — Glow par canal RGB. *Quand* : néon, lueur. `attrs` : `blur` (int2, "Glow Radius", défaut 20/20, PAS `radius`), `intensity` (défaut 1), `glowColor` (tint), `opacity`, `blendMode` (défaut 12 Plus), `gamma`, `whitePoint`, `complex` + `blurR/G/B`, `intensityRGB` (canaux séparés), `drawMode` (0 Result, 1 Glow Input).
- `dropShadowFilter` ✔ — Ombre portée. `attrs` : `amount` (flou, double2, défaut 5/5), `offset` (double2, défaut 5/-5), `rotation`, `shadowColor` (alpha = opacité de l'ombre, défaut 100/255). `innerShadowFilter` — Ombre intérieure.
- `lightingFilter` — Ombres de contact, ombres longues.
- `sceneGroup::lightSweepFilter` — Balayage de lumière. *Quand* : shine sur un logo, packshot premium.
- `vignetteFilter` — Vignettage.

### 7.3 Couleur
- `hsvAdjustmentFilter` — Hue/saturation/value. `brightnessAndContrast`. `curvesFilter`. `levels`. `gammaCorrectionFilter`. `blackAndWhite`. `invert`. `triToneFilter`. `gradientMapFilter` — remap par luminosité. `posterizeFilter`. `thresholdFilter`. `ditheringFilter`. `fill` — surcharge la couleur. `shiftChannels`.

### 7.4 Distorsion et styles
- `distortionFilter` — Distorsion pilotée par shader. `distortEdges` — Bords uniquement. *Quand* : contours organiques "papier".
- `sceneGroup::rippleFilter` — Ondulations. `sceneGroup::twistFilter` — Torsion. `sceneGroup::bulgeFilter` — Bulge/pinch. `sceneGroup::spheriseFilter` — Sphère. `mirrorFilter` — Miroir.
- `chromaticAberrationFilter` — Séparation RGB. *Quand* : glitch, impact. (`rgbSplitFilter` du catalogue précédent est introuvable dans `search_layer_types` : retiré.)
- `pixelateFilter` / `halftoneFilter` / `pixelSortingFilter` / `crtScanLines` / `sceneGroup::grainFilter` / `slitScanFilter` / `scrapeFilter` / `sharpenFilter` / `edgeDetection`.
- `sceneGroup::chromaKeyFilter` — Clé chroma.

### 7.5 Wipes (révélations)
- `linearWipe` ✔, `radialWipe`, `venetianBlinds` (filters). *Quand* : reveals rapides sans keyframes de masque. `linearWipe` attrs : `completion` (0-100 %, défaut 50, à animer ; PAS `progress`), `direction` (rotation en degrés), `feather` (PAS `softness`), `screenSpace`. Les deux autres : attrs à vérifier.
- `fill` (Fill Color, super `filter`) — surcharge la couleur d'un shape ; ne pas confondre avec `colorMaterial`.

### 7.6 Shaders (sources)
- `gradientShader` (sous-types `linearGradientShader`, `radialGradientShader`, `sweepGradientShader`, `conicalGradientShader`, `shapeGradientShader`) — Dégradés. *Quand* : fonds, fills de marque.
- `multiPointGradientShader` — Dégradé multi-points type mesh. *Quand* : fonds fluides modernes.
- `noiseShader` — Perlin/Value/Cellular. `voronoiShader`. `checkerboardShader`. `slaShader`. `colorShader` — couleur unie. `imageShader` — image/séquence/vidéo (produit, packshot).
- `blendShader` — Combine plusieurs shaders. `shapeToShader` — Shape comme shader.
- `skslShader` / `skslFilter` — Shader/filtre SkSL custom (valider avec `preflight_shader`).

---

## 8. Text

- `textShape` ✔ — Texte riche. *Quand* : tout titre/claim. `attrs` : `text` (richText), `font` ({font, style}, ex. `{"font":"Lato","style":"Regular"}`), `fontSize` (défaut 72), `horizontalAlignment` (0 Left, 1 Centre, 2 Right, 3 Justify ; PAS `alignment`), `verticalAlignment` (0 Top, 1 Middle, 2 Bottom, 3 Baseline), `letterSpacing` (Character Spacing), `wordSpacing`, `lineSpacing`, `paragraphSpacing`, `textBoxSize`, `autoWidth`, `autoHeight`, `autoScaleFontSize` (Shrink to Fit), `typeface` (connexion d'un node typeface, optionnel), `textPath` + `pathTravel` / `pathPush` / `pathLoop` (texte sur un path), `styleBehaviours` (applyFontSize, applyTypeface...), `materialBehaviours` (applyTextMaterial), `manipulators` (string manipulators), `array` (Formatting Inputs, `{0}`), fond de texte : `backgroundShape`, `backgroundMode`, `backgroundPadding`, `cornerRadius`. Fill par défaut `colorMaterial`.
- Générateurs de string (moteurs de texte, `textEngine`) : `textBlockUnicode` (Block), `textNumber` (Random Number), `textDate`, `textHash`, `textHex`. Opérateurs de string : `resizeString`, `shuffleString`, `unicodeManipulator`.
- `applyTypeface` — Fonte par regex. `applyFontSize` — Taille par regex. `applyFontStyle` — Underline, exposant. `applyOpenType` — Features OpenType (ligatures, chiffres). `applyCharacterSpacing` — Kerning procédural (tracking animé). `applyTextMaterial` — Fill/stroke par ligne, mot, caractère ou regex.
- `measureText` — Mesure une chaîne. *Quand* : dimensionner une card selon un texte.
- `typeface` / `typefaceArray` — Fontes indexables.
- `subMesh` + `meshDistribution` — Animer lettre par lettre.
- `visibility` — Typewriter.
- `textValue`, `textBlockUnicode` : moteurs internes du texte, ne pas instancier.

---

## 9. Camera

- `planarCamera` ✔ — Caméra 2.5D. *Quand* : mouvement de caméra sur une scène multi-plans (les layers doivent avoir `is3d` = 2.5D). `attrs` : `position` (double3, z = distance, défaut 879.13), `zoom` (défaut 879.13), `rotation` (double3), `cameraType` (0 Freeform, 1 Look At [défaut], 2 Guide), `lookAt`, `lookAtOffset`, `positionOffset`, `inputGuides` (guides), `blur` + `blurAmount` + `blurRange` (profondeur de champ), `fog` + `fogColor` + `fogRange`, `resolution`. PAS de `viewBox` ni `scale`.
- `cameraGuide` — Guide dont le cadre pilote une caméra (`cameraType` = Guide). *Quand* : cadrer des zones (zoom vers détail).
- `compConstraint` — Garde des éléments dans le cadre.

---

## 10. Particles / Dynamics

### 10.1 Particles
- `particleShape` — Conteneur de simulation (emitters + modifiers). `attrs` : `timeStep`.
- `particleEmitter` ✔ (BETA) — Émet depuis point, shape ou path. `attrs` : `emitterRate` (défaut 100, PAS `rate`), `lifespan` (s, défaut 5), `initialSpeed` (défaut 10, PAS `speed`), `initialDirection` + `directionType` (0 Angle, 1 Inwards, 2 Outward), `emitterShape` (0 Point, 1 Circle, 2 Square, 3 Input Shape, 4 Input Shape Perimeter), `inputShape`, `count` (Maximum Particles, 2000), `emitterType` (0 Time, 1 Distance), `duration`, `interval`, `probability`, `seed`, `size`. Connecter un `random` à `initialDirection`/`initialSpeed` pour varier.
- `distributionEmitter` — Émet depuis une distribution.
- `javaScriptEmitter` — Émetteur scripté.
- Modifiers : `forceModifier` (gravité, masse), `turbulenceModifier` (bruit), `vortexModifier`, `magneticModifier`, `speedModifier` (drag/limite), `pathModifier`, `goalModifier`, `flowFieldModifier`, `dataModifier` (ID/vie/vitesse), `visualModifier` (apparence), `imageModifier` (images), `javaScriptModifier`.
- Pour peupler : `particleDistribution` dans un `duplicator`.

### 10.2 Forge Dynamics (rigid body 2D)
- `forgeDynamicsShape` — Moteur physique.
- Forces : `attractorField`, `directionField`, `dragField`, `buoyancyField`, `pathField`, `vortexField`.
- Contraintes : `bridgeConstraint`, `distanceConstraint`, `pinConstraint`.
- Événements de collision : `bodySettingCollisionEvent`, `colorCollisionEvent`, `impulseCollisionEvent`, `stickyCollisionEvent`, `visibilityCollisionEvent`.

---

## 11. Tableau "Je veux obtenir X, utilise Y"

| Intention motion | Node(s) |
|---|---|
| Fond plein de la comp | `backgroundShape` |
| Rectangle / pill / cercle | `rectangleShape` / `capsuleShape` / `ellipseShape` |
| Logo vectoriel fourni | `svgShape` (ou `editableShape`) |
| Répéter N éléments en ligne/grille/cercle | `duplicator` + `linearDistribution` / `gridDistribution` / `circleDistribution` |
| Cascade d'apparition (stagger) | `duplicator` + `stagger` (`out` vers `shapeTimeOffset`) ou `rangeFalloff` (mode Transition) + `contextIndex` |
| Balayage d'un effet sur les clones (vague de couleur, d'échelle) | `value` + `rangeFalloff` (Transition, animer `transitionCompletion`) |
| Effet seulement dans une zone mobile | `falloff` (Circle/Rectangle/Shape) dans `falloffs` d'un `value` / `noise` / `pinch`, parenté à un `null` |
| Anneau / découpe par falloffs empilés | 2 `falloff` avec Layer Mode Normal puis Minus (ou Multiply) |
| Animer un fragment de logo SVG | `svgShape` + `subMesh` (+ `contoursToSubMeshes` si un seul path) |
| Ordre d'apparition aléatoire sans doublon | `sequence` |
| Accrocher un élément à un sommet / une arête | `pointConstraint` / `edgeConstraint` |
| Texte avec fond qui épouse les lettres | `textShape` (`backgroundShape` + `backgroundMode`) ou `subBoundingBox` |
| Texte sur une courbe | `textShape.textPath` (ou `bend`) |
| Overshoot garanti sans spring | `api.magicEasing(..., "SpringOut")` |
| Overshoot / rebond sur un mouvement | `spring` |
| Squash & stretch d'un objet qui rebondit | `squashAndStretch` |
| Respiration / wiggle / tremblement | `noise` (ou `oscillator`) |
| Rotation continue / compteur lié au temps | `frame` |
| Pulsation rythmée | `oscillator` / `wave` |
| Réaction à la musique | `sound` |
| Transition forme A vers forme B | `morph` / `blendShape` |
| Logo qui se dessine (trait) | `strokeMaterial` trim ou `splitPathUtility` / `travel` |
| Texte lettre par lettre | `textShape` + `subMesh` / `manipulator` + `visibility` |
| Objets le long d'une courbe | `duplicator` + `pathDistribution` (`inputShape`) |
| Tracking de texte animé | `applyCharacterSpacing` |
| Card qui épouse son texte | `boundingBox` + `layoutGroup` ou `measureText` |
| Layout auto (boutons, listes) | `layoutGroup` / `gridLayoutGroup` |
| Animer seulement une zone | `falloff` |
| Animer seulement certains clones | `rangeFalloff` |
| Contrôleur unique pilotant N attributs | `value` / `null` + connexions |
| Remapper une valeur (0-1 vers autre) | `numberRange` |
| Un seul control, variantes A/B | `valueBlend` / `customDropdown` / `ifElse` |
| Palette de marque par clone | `colorArray` + `contextIndex` |
| Textes/données par clone | `stringArray` / `spreadsheet` |
| Mouvement le long d'un trajet | `pathfinder` / `pathDistribution` |
| Objet qui regarde une cible | `lookAt` |
| Caméra pan/zoom | `planarCamera` (+ `cameraGuide`) |
| Coins arrondis / biseautés | `round` / `bevel` |
| Drapeau / ondulation | `wave` / `lattice` |
| Perspective sur mockup | `cornerPinShape` / `fourPointWarp` |
| Relief / profondeur | `extrude` / `3dMatrix` |
| Blobs liquides "goo" | `metaballs` |
| Découpe vectorielle (A moins B) | `boolean` |
| Reveal sans masque | `linearWipe` / `radialWipe` / `venetianBlinds` |
| Brillance sur logo / packshot | `sceneGroup::lightSweepFilter` + `glowFilter` |
| Ombre portée / profondeur | `dropShadowFilter` / `innerShadowFilter` |
| Flou de mise au point / entrée | `blurFilter` / `sceneGroup::gaussianBlurFilter` |
| Flou de vitesse | `sceneGroup::directionalBlurFilter` / `motionStretch` |
| Glitch | `chromaticAberrationFilter` / `pixelSortingFilter` / `pixelateFilter` |
| Grain film / texture | `sceneGroup::grainFilter` / `noiseShader` |
| Dégradé de fond | `gradientShader` / `multiPointGradientShader` |
| Image / vidéo produit | `imageShader` |
| Étincelles, confettis, fumée | `particleShape` + `particleEmitter` |
| Objets qui tombent et rebondissent | `forgeDynamicsShape` |
| Constellation de points reliés | `randomDistribution` + `connectShape` |
| Couleur dégradée sur une rangée de clones | `indexToColor` |
| Rig de personnage bras/jambe | `rubberHoseLimb` |
| Enchaîner des scènes dans le temps | `schedulingGroup` |
| Garder un élément dans le cadre | `compConstraint` |
| Compteur / date / timecode | `stringGenerator` |
| Shader sur mesure | `skslShader` (valider avec `preflight_shader`) |

---

## 12. Rappels de bon usage

- Rectangle : `dimensions`, pas `size` ; fill : `material.materialColor` ; stroke : `stroke.strokeColor` + `stroke.trim` à true avant `trimStart/trimEnd`.
- Noise : amplitude via `generator.minimum/maximum`, pas `amplitude`. Oscillator : `minimum/maximum`, pas `amplitude`.
- Toujours vérifier un nodeType inconnu avec `search_layer_types` puis `get_layer_definition` avant `api.create`.
- Préférer une chaîne procédurale (Duplicator + Distribution + Behaviour + Falloff) à des dizaines de keyframes : plus facile à ajuster pour le client.
- Un seul `value` / `null` de contrôle pour les paramètres qui reviennent (durée, couleur, intensité).
- Filtres coûteux (blur, glow, backgroundBlur, lighting) : les appliquer sur le group parent, pas sur chaque clone.
