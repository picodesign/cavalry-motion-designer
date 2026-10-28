# Astuces communauté et docs officielles Cavalry

Référence du skill `cavalry-motion-designer`. Chaque astuce cite sa source. Légende de fiabilité :

- [OFFICIEL] : documentation cavalry.studio (copyright 2026 Scene Group), lue directement.
- [BLOG] : article tiers (School of Motion, Lester Banks, CG Channel, Digital Production, etc.), à croiser.
- [ANCIEN] : source antérieure à Cavalry 2.x (2019-2022), à revérifier avant d'affirmer.
- [INCERTAIN] : une seule source, source secondaire, ou contradiction entre sources.

## 0. Limites de cette recherche (à lire d'abord)

- Mise à jour 28 oct. 2026 (second passage, accès direct, voir section 13) : issues GitLab publiques ACCESSIBLES (descriptions seulement ; fils de commentaires non lisibles sans connexion, donc non lus). Reddit r/Cavalry : BLOQUÉ (HTTP 403 "Blocked" sur old.reddit.com .json), rien repris. Discord : exige une connexion, non lu. Forum : aucune URL de forum officiel n'est liée depuis cavalry.studio (la communauté officielle = Discord + GitLab) ; les hôtes forum.cavalry.studio, community.cavalry.studio, scenegroup.discourse.group ne résolvent pas. YouTube : redirige vers un écran de consentement, non lu. Ne jamais présenter une astuce comme "vue sur le forum/Discord/Reddit" : seule la section 13 vient réellement de GitLab.
- Les URL `docs.cavalry.scenegroup.co` et `cavalry.scenegroup.co/user-guide/` redirigent vers `https://cavalry.studio/` (301). Utiliser `cavalry.studio/docs/...`.
- Le dossier docs officiel contient une section Tips (`https://cavalry.studio/docs/tips/ai-automation-with-claude/`) et une FAQ (`/docs/faq/canva-ai-and-cavalry/`). Ces deux pages n'ont pas été lues en détail ; à consulter via le MCP `read_doc` / `search_docs` plutôt que par le web.
- Le MCP cavalry (`search_docs`, `read_doc`, `search_api`, `read_example`) reste la source prioritaire pour la version installée. Ce fichier complète, il ne remplace pas.
- Aucune source trouvée sur : boucles parfaites (loop) spécifiques à Cavalry, performances chiffrées, erreurs de débutant issues de Reddit. Ces sections sont donc minces et marquées comme telles.

## 1. Contexte produit et versions

- Cavalry est maintenant distribué par Canva (Scene Group intégré). Le site scenegroup.co pointe vers "Cavalry by Canva" ; une version legacy reste disponible. Source : résultat de recherche sur https://cavalry.scenegroup.co/ [INCERTAIN, page non lue en direct].
- Version gratuite pour les individus, y compris usage commercial ; studios/organisations : compte Canva Enterprise ou Education payant. Source : https://schoolofmotion.com/blog/getting-started-with-cavalry-5-things-every-beginner-should-know et https://schoolofmotion.com/blog/cavalry-houdini-of-2d-after-effects [BLOG, les deux disent de vérifier les conditions actuelles]. Une revue tierce 2026 affirme que le gratuit est limité à MP4 1080p et que ProRes est Pro (https://superrendersfarm.com/it/article/cavalry-motion-design-review-2026) [INCERTAIN, contredit en partie le bloc ci-dessus]. Vérification du 28 oct. 2026 : la page d'accueil officielle https://cavalry.studio/en/ dit « Free for Individuals… no restrictions or payment needed » et ne cite « Pro » que pour les anciennes licences (≤ 2.6.1) ; elle ne détaille pas les formats d'export, et la doc marque certaines fonctions « Pro ». La revue tierce est probablement périmée, mais non tranché : tester l'export réel (ProRes, Lottie) avant de le promettre.
- Historique de versions (tiers) :
  - 1.2 : suppression du watermark, plafond de rendu gratuit à Full HD. https://www.cgchannel.com/2021/10/scene-group-ships-cavalry-1-2/ [ANCIEN].
  - 2.0 : caméras de scène animables (effets 2.5D), système de particules expérimental, Components, lecture environ 200 % plus rapide en moyenne, rendu en arrière-plan. Sources : https://renderu.com/en/news/post/25117 et CG Channel [BLOG].
  - 2.5 (oct. 2025) : Referencing (une scène `.cv` importée comme Asset dans une autre), Tracking Tool, 11 nouveaux Filters, Export to Project, options de profondeur de bits ProRes/PNG sur macOS (non précisé pour Windows), API JavaScript étendue, Layout Groups avec wrapping. https://digitalproduction.com/2025/10/13/cavalry-2-5-adds-referencing-tracking-luminance-blur-and-more/ [BLOG].
  - Les docs de Render Manager mentionnent "Cavalry 2.6.1 et antérieur" pour l'upload Canva : la version 2.6.x existe donc. https://cavalry.studio/docs/user-interface/menus/window-menu/render-manager/ [OFFICIEL].
- Conséquence pratique : toute astuce datée de 2019-2022 (revues, premiers tutoriels) doit être testée sur la version installée avant usage. Ex. la remarque "les connexions n'ont ni offset ni échelle, seulement 1:1" vient d'une revue de la 1.0 (https://www.provideocoalition.com/is-cavalry-the-after-effects-killer/) [ANCIEN] : ne pas la tenir pour vraie en 2.x sans test.

## 2. Philosophie et différences avec After Effects

Sources : https://schoolofmotion.com/blog/getting-started-with-cavalry-5-things-every-beginner-should-know, https://schoolofmotion.com/blog/cavalry-houdini-of-2d-after-effects [BLOG].

| After Effects | Cavalry |
|---|---|
| Piles de calques + keyframes | Systèmes : tout peut se connecter à tout |
| Pick whip / expressions pour lier | Connexions d'attributs + Behaviours (plus de 40) |
| N formes animées en séquence : keyframes ou expressions | 1 forme + Duplicator + Behaviour Stagger |
| Variantes : ajuster à la main, rendus séparés | Dynamic Rendering (lot de rendus piloté par un index) |
| RAM preview | Lecture temps réel par défaut |
| Compositing, plugins, intégration Adobe : points forts | Plus faible sur ce terrain ; beaucoup de designers utilisent les deux |

- Correspondance d'interface (selon School of Motion) : Viewport = panneau Comp ; Timeline = Timeline ; Attribute Editor ≈ Effect Controls ; Scene Window = ordre des calques et connexions. La source elle-même est approximative sur cet équivalent ; ne pas en tirer de règle stricte. [INCERTAIN]
- Ne pas importer ses réflexes AE : penser "système", pas "empilement". École de pensée résumée par SoM : "anything can connect to anything".
- Les Behaviours sont plus rapides mais moins précis qu'une expression personnalisée. SoM, même article.
- Pipeline fréquent : Cavalry pour le motion/logo, After Effects pour le compositing final (étalonnage, effets, audio). https://www.provideocoalition.com/is-cavalry-the-after-effects-killer/ [ANCIEN pour le contexte, pipeline toujours cité par SoM].
- Cavalry n'ouvre pas les projets After Effects. Seuls les rendus de Cavalry retournent dans AE, et le vectoriel (SVG, Illustrator) vient dans Cavalry. https://motionimo.xyz/blog/cavalry-vs-after-effects [BLOG, comparatif tiers, [INCERTAIN]].
- Les fragilités d'expressions AE ("une faute de frappe casse tout") sont l'argument d'Envato pour les Behaviours : https://elements.envato.com/learn/cavalry-motion-graphics [BLOG, argumentaire marketing].

## 3. Workflows efficaces

### 3.1 Duplicator, base de presque tout

- Commencer par une forme + un Duplicator, tester grille, cercle, aléatoire. Pour SoM, ça apparaît dans presque tous les projets. https://schoolofmotion.com/blog/getting-started-with-cavalry-5-things-every-beginner-should-know [BLOG].
- Donner un seed distinct à chaque propriété variable (forme, couleur, rotation) pour varier l'une sans toucher aux autres. https://schoolofmotion.com/blog/cavalry-houdini-of-2d-after-effects [BLOG].
- Utiliser l'Index Context (index de duplicata) via des connexions pour piloter couleur, échelle, rotation ou décalage de temps, au lieu d'écrire des expressions. Même source.
- Lier un String Array au nombre d'éléments du Duplicator : ajouter une entrée crée un nouvel élément (liste de noms, données de tableur). Même source.
- Ajouter un Behaviour : clic droit sur l'attribut > Add Behaviour, puis réglage dans l'Attribute Editor. https://schoolofmotion.com/blog/getting-started-with-cavalry-5-things-every-beginner-should-know [BLOG].
- Garder la lecture en boucle pendant le travail plutôt que de prévisualiser à la fin. Même source.

### 3.2 Rigs réutilisables

- Components (2.0+) : regroupent des calques en conteneur personnalisé et choisissent quels attributs sont exposés dans l'UI. https://renderu.com/en/news/post/25117 [BLOG]. Les détails d'API ne sont pas documentés dans les sources lues : passer par `search_docs` du MCP.
- Referencing (2.5) : une scène `.cv` importée comme Asset ailleurs, les modifs de la source se propagent. Bon pour une bibliothèque de rigs/logos. Attention à la gestion de chemins et au versioning. https://digitalproduction.com/2025/10/13/cavalry-2-5-adds-referencing-tracking-luminance-blur-and-more/ [BLOG].
- Pré-compositions : régler Background Alpha à 0 pour l'export Lottie ou alpha. https://cavalry.studio/docs/user-interface/menus/window-menu/render-manager/lottie-export/ [OFFICIEL].
- Export to Project (2.5) : regroupe scène et assets liés dans un dossier, utile pour archiver ou transmettre. Digital Production, même lien [BLOG].
- Hériter l'animation d'un autre objet avec décalage de temps (inherited animation + Time Offset) : tuto Ian Waters, https://lesterbanks.com/2020/11/how-to-offset-time-from-inherited-animation-in-cavalry/ [ANCIEN, 2020, à revérifier en 2.x].

### 3.3 Organisation de scène

- Les scripts "Canvalry" de l'équipe Motion Powerhouse de Canva fournissent : Renamer, Consolidate Assets, Remove Unused Assets, Reduce Compositions, Explode Shape Layers, Find and Replace Text, Localiser (export/import CSV de textes pour traduction), CSS Gradient Converter, Set All Image Shaders to Mipmaps, Set Background Alpha to 0. https://github.com/phillip-motion/Canvalry-scripts (licence MIT).
  - Caveats de la page : outils internes, "mostly vibe coded", non supportés par l'équipe Cavalry ; certains font des appels web (vérification de mise à jour) ; Reduce Compositions et Remove Unused Assets suppriment du contenu, sauvegarder avant. Dossier d'installation et version requise non précisés.
  - Inférence du skill : lire le code d'un script tiers avant de l'exécuter via `execute_script`.

## 4. Animation de texte par caractère

- Technique historique : le Sub Mesh Deformer découpe le texte (ou un SVG, ou un Duplicator) en sous-maillages animables individuellement. Source : https://lesterbanks.com/?p=58920 ("How to Do Per-Character Type Animation in Cavalry", 18 mai 2020, d'après Chris Hardcastle) [ANCIEN].
  1. Ajouter un Sub Mesh Deformer au texte.
  2. Ajouter un Behaviour Stagger pour obtenir une ondulation (ripple).
  3. Pour des décalages irréguliers, remplacer par Random.
  4. Pour élargir : mettre le texte dans un Duplicator, second Stagger sur Shape Time Offset et Shape Position.
  5. Ajouter un Color Array sur la Fill Color du texte.
  6. Pour animer par mot : régler Recursion du Sub Mesh.
- Cycle de couleurs par ligne, mot ou caractère : tuto Ian Waters, https://lesterbanks.com/2020/08/how-to-cycle-through-colors-with-cavalry/ [ANCIEN].
- À vérifier en 2.x : noms exacts des attributs (Recursion, Shape Time Offset) et existence d'alternatives plus récentes. Utiliser `search_layer_types` / `get_layer_definition` du MCP avant de coder.
- Pas de tutoriel Cavalry de "logo reveal" complet trouvé. L'équivalent AE (Noble Desktop) n'est utile que comme référence conceptuelle : https://nobledesktop.com/learn/after-effects/text-animation-animating-text-character-by-character [hors sujet Cavalry].
- Texte et Lottie : le texte est exporté comme formes, non éditable (cf. section 7.3).

## 5. Logo reveals

Aucune source communautaire dédiée trouvée. Principes déduits des sources lues, à traiter comme hypothèses de travail [INCERTAIN] :

- Importer le logo en SVG avec "Separate Layers" pour animer chaque pièce séparément (voir 6.1), puis Stagger/Duplicator/Time Offset pour le séquencer. SoM souligne que chaque forme d'un SVG importé s'anime indépendamment, chose pénible à la main dans AE : https://schoolofmotion.com/blog/everything-make-web-ui-animations-lottiefiles et le résumé de la recherche sur https://schoolofmotion.com/blog/cavalry-houdini-of-2d-after-effects [BLOG, extrait indirect].
- Pour un reveal par trait : Trim Start/End du Stroke et Path Animation sont les attributs bien supportés à l'export Lottie (section 7.3), donc à privilégier si la cible est web.
- Fournir en sortie alpha (ProRes 4444) à la taille exacte de la comp AE pour que l'asset tombe aligné : https://schoolofmotion.com/blog/cavalry-houdini-of-2d-after-effects [BLOG].

## 6. Import : SVG, Illustrator, After Effects

### 6.1 SVG et Illustrator

Source : https://cavalry.studio/docs/nodes/general/vector-artwork-support/ [OFFICIEL].

- Glisser un SVG dans le Viewport ou coller des données SVG. Une boîte de dialogue propose : Asset Layer (SVG en un seul calque) ou Separate Layers (chaque pièce devient une Editable Shape avec Fill et Stroke).
- Alt/Option en glissant un SVG dans le Viewport ou la Scene Tree : va directement en Separate Layers.
- Copier-coller depuis : Illustrator (Edit > Copy), Figma (clic droit sur un tracé > Copy/Paste as > Copy as SVG), Affinity (Edit > Copy, après avoir activé "Copy Items as SVG" dans Settings > General > Miscellaneous).
- Supporté à l'import : opacité, dégradés, masques d'écrêtage, texte.
- Limites : seul l'alignement de trait Centre est supporté ; traits intérieur/extérieur variables selon l'app ; blend modes non listés comme supportés ; polices manquantes remplacées par la police par défaut, donc vérifier les mises en page de texte. La doc prévient que "le support du svg peut être un peu mitigé" : tester chaque fichier.
- Conseil de skill : demander à l'utilisateur d'aplatir/outliner les textes et d'éviter traits intérieurs/extérieurs dans Illustrator avant l'export.

### 6.2 After Effects

- Pas d'import de projets `.aep` (voir section 2) [INCERTAIN, source tierce]. Les passerelles passent par SVG, rendus vidéo/alpha ou Lottie.
- Lottie Importer : script externe lié depuis https://github.com/phillip-motion/Canvalry-scripts (dépôt séparé, non lu) [INCERTAIN].
- Rappel côté Lottie/AE (hors Cavalry) : convertir les illustrations en shape layers avant export. https://github.com/airbnb/lottie/blob/master/after-effects.md. Non applicable à un flux Cavalry vers Lottie.

## 7. Export

### 7.1 Formats (Render Manager)

Source unique pour ce bloc : https://cavalry.studio/docs/user-interface/menus/window-menu/render-manager/ [OFFICIEL].

- Image : APNG, GIF, JPEG, PNG, Sprite Sheet, WebP.
- Vidéo : MP4 (H.264) ; QuickTime (Motion JPEG, Uncompressed 422, ProRes) ; WebM (VP8, VP9, AV1).
- Audio seul : AAC, AIFF, WAV.
- Vectoriel/code : Lottie (JSON) ; SVG (séquence de SVG, pas un SVG animé).
- Alpha : géré par la plupart des formats image ; ProRes 4444 et 4444 XQ supportent l'alpha ; WebM alpha pas supporté actuellement. Régler Background Alpha de la Composition à 0.
- Licence des formats : la page de prix liste MP4, WebM, ProRes, PNG, JPG, WebP, APNG, Sprite Sheet, SVG, Lottie (Lottie Pro uniquement d'après les docs : "Pro features are only available with a Professional licence"). Vérifier la licence réelle de l'utilisateur avant de promettre ProRes ou Lottie. [INCERTAIN, voir section 1]

### 7.2 File de rendu, résolution, fps

- Les Render Queue Items sont enregistrés avec la scène ; les éléments décochés ne sont pas rendus ; "Render All" lance tous les éléments actifs.
- L'onglet Compositions rend plusieurs compositions avec Output/Format/Dynamic partagés.
- Background Rendering : rendu dans un second processus sur une copie temporaire de la scène, on peut continuer à travailler. Les assets non vidéo sont tenus en RAM. Ne pas déplacer ni modifier les assets vidéo pendant ce rendu.
- Resolution Scale multiplie la résolution de la composition.
- Plafond MP4 (H.264) : 9 437 184 pixels (36 864 macro-blocs de 16x16). Plus grand 16:9 : 4096 x 2304. Au-delà, mise à l'échelle proportionnelle automatique.
- Fréquence d'images : la page n'a pas de réglage fps de rendu distinct ; elle se règle sur la composition. "Use Composition Playback Step" respecte le step de la composition, sinon toutes les images sont rendues.
- Frame Range Mode : Composition Start/End, Playback Start/End, Current Frame, Custom.
- Retime Render (icône engrenage) : définit une nouvelle durée en timecode MINUTE:SECOND:FRAME.
  - Allonger plutôt que raccourcir (raccourcir peut sauter des images importantes).
  - Utiliser l'interpolation Stepped pour les animations d'une seule image, sinon elles s'étirent au retiming.
  - Séquence d'images ou vidéo étirée = images dupliquées.
- Nom de fichier avec `/` ou `\` crée des dossiers (ex. `MonDossier/Composition1`).
- Scripts Setup / Pre-Render / Post-Render disponibles par élément de file.
- Upload Canva : avec le compte connecté ; avant 2.6.1 il fallait lier un compte via la page Account.
- Export JSON de métadonnées possible (JSON, Simple Traits JSON, NFT Traits JSON).

### 7.3 Dynamic Rendering (variantes par lot)

Source : même page Render Manager [OFFICIEL], et idée de seed 0-99 sur https://schoolofmotion.com/blog/cavalry-houdini-of-2d-after-effects [BLOG].

- Activer Dynamic Render, définir un Render Range (inclusif : 0..5 donne 6 rendus).
- Dynamic Index transmet une valeur par rendu à d'autres attributs ; Dynamic Index Offset décale pour les aperçus.
- Ensure Unique File Names : un dossier par rendu, noms suffixés. Le token `<Dynamic>` place l'index dans les noms.
- Astuce SoM : animer un seed de 0 à 99 sur 100 images pour exporter 100 variantes en séquence PNG.
- Un Layer Id ne se connecte pas directement à une métadonnée ; passer par un Behaviour Value.

### 7.4 Export Lottie

Source : https://cavalry.studio/docs/user-interface/menus/window-menu/render-manager/lottie-export/ [OFFICIEL]. Accès : File > Export Lottie... ou Render Manager.

Limites :
- Le texte est exporté en formes (non éditable).
- Pas de Track Mattes (utiliser un Clipping Mask).
- Courbes d'animation en loop non supportées.
- Pas de masque sur un Group/Parent ; avec masques animés, utiliser Path Animation.
- Séquences d'images non supportées ; images non embarquées dans le `.json` : dossier `images` zippé avec le `.json`.
- Le parent est rendu devant : préférer un Group ou Null.
- Trim Start > Trim End mal géré par le lecteur LottieFiles.

Non supportés : tous les Filters (flous, Levels, TriTone...), Noise/SkSL/Color Shader, Shape to Shader, dégradés Sweep/Conical, Dash Pattern, Skew, Shape Opacity (utiliser Fill/Stroke Alpha), Color > Alpha (utiliser Fill/Stroke Alpha), Linear Gradient avec Gradient Scales with Rotation.

Sans baking (fichiers les plus légers, sans Deformers connectés) : Position, Rotation, Fill/Stroke Alpha, Stroke Width, Trim Start/End/Travel, Path Animation, attributs de Star (Point Count, Radius, Inner Radius).

Supporté mais fichiers lourds : Deformers, Magic Easing sur tracés, attributs de primitives animés (sauf Star), Rig Control/Animation Control avec Path Animation, Duplicator.

Baking : réglage Lottie Baking dans l'onglet Advanced de la forme. Still (export lourd sans animation), Animated ou Nuclear (animation manquante), Automatic (défaut).

Conséquence pour le skill : si la cible est Lottie, éviter dès la conception Filters, Track Mattes, Skew, Shape Opacity, loops de courbe.

### 7.5 Handoff vers After Effects

- ProRes 4444 avec alpha à la même taille que la comp AE. https://schoolofmotion.com/blog/cavalry-houdini-of-2d-after-effects [BLOG].
- Scene packages pour le Cavalry Player (mentionné par SoM, détails non lus). Doc : https://cavalry.studio/docs/applications/cavalry-player/ [non lue].

## 8. Boucles (loops)

- Aucune source Cavalry fiable trouvée sur le bouclage parfait. Ne pas inventer de procédure.
- Éléments établis : les courbes d'animation en loop ne sont pas exportables en Lottie (7.4) ; un Behaviour périodique ou un Time Offset sur copies Duplicator est l'approche procédurale classique, mais ce point n'est pas confirmé par les sources lues [INCERTAIN].
- Procédure sûre dans ce skill : vérifier la boucle en rendant la dernière image et la première, comparer par `snapshot_layer` ou aperçu, et s'assurer que l'image N+1 égale l'image 0 (durée = N images, sans doublon de fin).

## 9. Scripting JavaScript et connexions

- Calques JavaScript (Utility, Shape, Deformer, Emitter, Modifier) : https://cavalry.studio/docs/nodes/general/javascript-layers/ [OFFICIEL, via extrait de recherche].
  - Entrées créées avec le bouton +, nommées par défaut `n0`, `n1`... ; renommage par clic droit > Rename sur l'attribut.
  - Les types non concordants sont convertis automatiquement, mais la doc recommande de faire correspondre les sorties pour mieux contrôler la précision flottante.
- 1.3 : modules Context (JavaScript Utility), Cavalry (Utility et Editor), API (Editor) ; Script UIs, Web APIs, scripts Pre/Post-render. https://cavalry.studio/docs/tech-info/release-notes/1.3/1-3-0-release-notes/ [OFFICIEL, via extrait].
- 2.5 : API JavaScript étendue. Vérifier la compatibilité de scripts existants avec l'API révisée. https://digitalproduction.com/2025/10/13/cavalry-2-5-adds-referencing-tracking-luminance-blur-and-more/ [BLOG].
- Annonce historique du support JS : https://lesterbanks.com/2022/02/cavalry-is-adding-javascript-support/ [ANCIEN].
- Scripts utilitaires avec Easey (graphique de vitesse), Tiny Palette, etc. : voir section 3.3.
- Dans ce skill, prioriser `search_api`, `get_api_function`, `preflight_script` du MCP avant `execute_script`.
- Doc "Tips" officielle sur l'automatisation par IA (Claude) : `https://cavalry.studio/docs/tips/ai-automation-with-claude/` [non lue ; à consulter via `read_doc` car directement pertinente pour ce skill].

## 10. Performances

- Les scènes très lourdes (grands nombres de Duplicators, systèmes de particules complexes) ralentissent la lecture temps réel. https://schoolofmotion.com/blog/getting-started-with-cavalry-5-things-every-beginner-should-know [BLOG].
- Filtres coûteux comme Luminance Blur sur de longues séquences d'images : tester les performances. Digital Production 2.5 (lien section 3.2) [BLOG].
- Lottie : Deformers, Magic Easing sur tracés et Duplicator produisent des fichiers lourds (7.4).
- Set All Image Shaders to Mipmaps (Canvalry scripts, section 3.3) cible les images lourdes ; effet non mesuré dans les sources [INCERTAIN].
- Rendu : Background Rendering libère l'interface ; les assets non vidéo restent en RAM.
- Les chiffres de rapidité ("dramatiquement plus rapide") ne sont ni chiffrés ni benchmarkés dans les articles de SoM ; ne pas les citer comme faits. 2.0 annonce environ 200 % de lecture en plus en moyenne (source RenderU, [BLOG]).
- Aucune astuce de performance issue du forum ou de GitLab n'a pu être vérifiée.

## 11. Erreurs de débutant

Sources : SoM (lien section 2) ; comparatif https://motionimo.xyz/blog/cavalry-vs-after-effects [BLOG].

- Garder les habitudes AE (calques, keyframes partout) au lieu de Behaviours et connexions.
- Animer à la main ce qu'un Behaviour fait (Noise, Random, Stagger, Modulate, Morph, Bend).
- Chercher l'équivalent exact de chaque outil AE : la terminologie diffère et l'interface désoriente au début. SoM suggère deux sessions sans deadline.
- Attendre la fin pour prévisualiser : le temps réel permet de juger le timing en continu.
- Procédural : plus facile si on connaît déjà les bases de l'animation sur timeline (comparatif tiers) [INCERTAIN].
- Exporter en Lottie sans vérifier les limites (filtres, mattes, skew) : voir 7.4.
- Oublier Background Alpha à 0 pour l'alpha.
- Dépasser le plafond MP4 (4096 x 2304 en 16:9) et recevoir un export réduit sans l'avoir voulu.
- Retimer un rendu à la baisse : images perdues.
- SVG avec polices non installées ou traits intérieurs/extérieurs : rendu différent.

## 12. Synthèse d'usage pour le skill

1. Avant d'affirmer une fonctionnalité, vérifier la version avec les outils MCP ; ces astuces sont des pistes, pas des spécifications.
2. Pour une cible web, concevoir dès le départ en fonction de la liste "sans baking" Lottie.
3. Pour un livrable vidéo, MP4 H.264 est plafonné en pixels ; ProRes 4444 pour l'alpha ; WebM n'a pas d'alpha.
4. Pour des variantes (langues, couleurs, tailles), privilégier Dynamic Rendering et String Arrays plutôt que des copies de scène.
5. Les points marqués [ANCIEN] ou [INCERTAIN] doivent être annoncés comme tels à l'utilisateur.
6. Sources : GitLab `mfn-public/cavalry` est interrogeable sans connexion via l'API (section 13). Discord et r/Cavalry restent non couverts (connexion / blocage).

## 13. Forum / GitLab / Reddit (lu directement le 28 oct. 2026)

Statut des sources :
- GitLab issues (API publique `https://gitlab.com/api/v4/projects/mfn-public%2Fcavalry/issues?search=...`, redirige vers `scenegroup-public/cavalry`) : LU. Seules les descriptions d'issues sont publiques ; `/notes` (commentaires) répond 401, donc les réponses de l'équipe et les workarounds en commentaires ne sont PAS connus. Une issue "opened" n'est pas confirmée corrigée ni reproductible sur la version installée. Les issues sont des bugs/demandes, pas des tutos : tout ce qui suit sert de "pièges connus", étiqueté [GITLAB-ISSUE].
- Reddit : 403 bloqué, non contourné. Discord : connexion requise, non lu. Forum officiel : introuvable (pas de lien depuis cavalry.studio). YouTube : écran de consentement, non lu ; playlists officielles liées depuis cavalry.studio, par ex. https://www.youtube.com/playlist?list=PL3ZRk7VwZVnizMpkOm2No2FoeitDIaf8f (titres non lus).
- Versions vues dans les issues : 2.6.0, 2.7.2, 2.8 (Affinity .af, oct. 2026). Les docs/notes de version 2.7-2.8 ne sont pas relues ici.

Base URL des issues : https://gitlab.com/scenegroup-public/cavalry/-/work_items/<numéro>

### 13.1 Export et rendu
- Couleurs "délavées" à l'export MP4/QuickTime par rapport à l'éditeur : #296, 10 oct. 2023, ouvert, réponse inconnue. Piège de gestion de couleur probable ; toujours comparer un export à la vue et vérifier le lecteur (QuickTime vs VLC) avant livraison. [GITLAB-ISSUE, cause non confirmée]
- MP4 vide si la composition est plus petite que 640x480 (largeur < 640 ET hauteur < 480) : #273, 31 janv. 2022, Cavalry 1.2.1 ; QuickTime fonctionnait. Pour un petit format, exporter en QuickTime/WebM/PNG ou agrandir via Resolution Scale. [ANCIEN, à retester en 2.x]
- Corruption de frames isolées (blocs rouge/jaune) dans un export vidéo d'icône animée : #338, 24 mars 2026, ouvert. Après tout export, scruber la vidéo entière, pas seulement le début. [GITLAB-ISSUE]
- ProRes 422 HQ importé affiché à 0 image (régression vs 2.3.2) : #322, 12 mars 2025. Si un footage ProRes apparaît vide, tester une autre variante de codec. [GITLAB-ISSUE]
- Image Shader avec vidéo : lent, images sautées, gel, impact sur d'autres apps (macOS) : #334, 27 janv. 2026. Éviter de piloter de la vidéo via Image Shader pour un rendu fiable ; précalculer la vidéo en amont. [GITLAB-ISSUE]
- Lottie : Stroke Width mis à l'échelle quand le lecteur web redimensionne (trait de 1 px) : #307, 6 mai 2024, fermé (résolution inconnue). Clipping/mask/Boolean absents de l'export Lottie : #285, 18 janv. 2023. Cohérent avec section 7.4 ; privilégier Clipping Mask et tester dans le lecteur cible. [GITLAB-ISSUE]

### 13.2 Boucles et temps
- Motion blur absent des répétitions en état "Loop After" de courbes bouclées : #274, 26 fév. 2022, ouvert. Piège de boucle : le flou n'est appliqué que dans le segment keyframé d'origine. Si le flou compte, keyframer la boucle sur toute la durée ou préférer un Behaviour périodique. [ANCIEN, à retester]
- Courbes bouclées + Stagger sur Time Offset d'un Sub Mesh (texte, recursion 3) : les valeurs bouclées ne sont pas lues au-delà de la plage de la composition, la boucle se fige en fin : #96, 13 fév. 2020, ouvert. Pour une boucle de texte par caractère, étendre la plage de composition avec de la marge et recadrer le rendu (Frame Range Custom). [ANCIEN, contournement déduit du skill, non vu sur GitLab]
- Impossible de boucler une pré-comp dans la comp principale (il fallait la dupliquer et décaler dans le temps) : #161, 14 juin 2020, ouvert. À vérifier en 2.x (Pre-Comp Overrides existent maintenant). [ANCIEN]
- Motion blur ignoré avec un masque, blend mode désactivé quand le flou est actif : #268, 24 nov. 2021. Pour un logo avec blend mode, tester le flou avant de s'y engager. [ANCIEN]

### 13.3 Texte et scripting
- Polices variables : pas de contrôle des font-variation-settings par caractère ; le contournement décrit par le rapporteur est TextArray + Duplicator sur un Text Shape, avec positionnement manuel de chaque lettre (lourd, à refaire si l'axe de largeur change) : #157, 13 juin 2020, ouvert. Depuis, l'animation de polices variables est citée comme acquise (#328, 19 sept. 2025), mais le par-caractère est à vérifier avec `get_layer_definition`. [ANCIEN/INCERTAIN]
- Polices avec un seul style accessible dans le menu : #328, 19 sept. 2025 ; police ajoutée comme Asset non appliquée au texte sur macOS : #331, 21 déc. 2025. Piège : pour les polices non installées, les installer au niveau système plutôt que compter sur l'import Asset. [GITLAB-ISSUE]
- Text Animation Presets (menu Create) faisaient planter 2.0.3 : #302, 7 mars 2024, fermé. Glyphes spéciaux collés dans le Custom String du String Manipulator font planter 2.7.2 : #341, 1er juin 2026, ouvert. Sauvegarder avant ces opérations. [GITLAB-ISSUE]
- JavaScript Deformer : seul le Sub-Mesh d'index 0 est transformé (erreur console "Attempting to set point positions on a non existent mesh") quand la forme a plusieurs Sub-Meshes (Duplicator, SVG) : #294, 7 sept. 2023, ouvert. Dans un script, ne pas supposer un seul mesh ; tester avec une forme à Sub-Meshes avant de livrer. [GITLAB-ISSUE]
- Variable d'un Shape JavaScript animée : erreur "Couldn't find Attribute with path ..." à la sélection de keyframe : #280, 11 août 2022. Préférer piloter ces valeurs par connexion ou Behaviour. [ANCIEN]
- Duplicator + Look At : l'attribut Shape Rotation est grisé mais on peut quand même connecter : #238, 22 mars 2021. Un attribut grisé ne signifie pas toujours "non connectable". [ANCIEN]
- Behaviour Random sur le rayon d'une étoile dupliquée : déformations/clipping tant que Min = Max n'est pas défini : #102, 2020, fermé. [ANCIEN]

### 13.4 Performances et stabilité
- Oscillator + falloff sur Duplicator de type halftone : ralentissement/plantage (matériel 2020) : #186, 6 août 2020, ouvert. Limiter le nombre de copies sous Oscillator + falloff. [ANCIEN]
- Attribute Editor en Live Mode : gel avec Select All à partir de ~50 calques : #227, 2 janv. 2021. Désactiver Live Mode sur les scènes chargées. [ANCIEN]
- Viewport/Time Editor dysfonctionnels sur un portable en 2.6.0 : #335, 6 fév. 2026 (GPU/pilotes suspectés). [GITLAB-ISSUE]
- Referencing 2.5+ : les Pre-Comp Overrides d'une scène référencée se réinitialisent à chaque rechargement (nouvelle entrée par défaut à l'index 0) : #345, 3 oct. 2026, ouvert. Ne pas compter sur les overrides d'une composition référencée sans vérifier après réouverture. [GITLAB-ISSUE]
- Import Affinity (.af, nouveau en 2.8) : les artboards aplatissent tout en une image, vecteurs et texte rastérisés : #346, 4 oct. 2026, ouvert. Pour un logo, passer par SVG (section 6.1), pas par .af. [GITLAB-ISSUE]
- Affirmation du skill vérifiée par #275 (14 mars 2022) : l'import de projets After Effects n'existe pas (demande de fonctionnalité). Cohérent avec section 2.

### 13.5 Sections sans contenu vérifié
Logo reveals, easing, workflows de pro : aucune issue GitLab utile, et Reddit/Discord/YouTube non accessibles. Les sections 4, 5 et 8 restent donc basées sur docs et blogs.
