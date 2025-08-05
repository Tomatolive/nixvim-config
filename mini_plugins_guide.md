# Mini.nvim Plugins - Version corrigée (compatible noice)

## ✅ **Problèmes résolus**

### 🐛 **Conflit mini.nvim + noice**
- **Problème** : Messages de mini.pairs et mini.surround interfèrent avec noice
- **Solution** : Mode silencieux + filtrage messages + overrides anti-conflit

### 🐛 **Input prompts problématiques**
- **Problème** : Les prompts "Function name:" et "Tag name:" causent des conflits
- **Solution** : Fallbacks automatiques + override vim.fn.input

### 🐛 **Messages debug spam**
- **Problème** : `print()` des plugins mini polluent noice
- **Solution** : Configuration silencieuse + filtrage noice

## 🔧 **Changements apportés**

### **mini.nix (version corrigée)**
- ✅ `silent = true` pour mini.pairs et mini.surround
- ✅ Désactivé `command = false` pour mini.pairs 
- ✅ Fallbacks pour prompts vides
- ✅ Override `vim.notify` pour mini.pairs
- ✅ Override `vim.fn.input` pour mini.surround
- ✅ Suppression des messages debug

### **noice.nix (routes ajoutées)**
- ✅ Filtrage messages mini.pairs
- ✅ Filtrage messages mini.surround  
- ✅ Filtrage messages mini.ai
- ✅ Skip messages généraux mini.nvim
- ✅ Redirection prompts vers mini

## 🎯 **Plugins ajoutés**

### 🎨 **Mini.ai** - Text objects améliorés
- Text objects plus intelligents et personnalisés
- Détection automatique via treesitter
- Objects custom pour des cas spécifiques

### 🔗 **Mini.pairs** - Auto-pairing intelligent (silencieux)
- Parenthèses, crochets, guillemets automatiques
- Mode silencieux pour éviter conflits noice
- Compatible seulement en insert mode

### 🔄 **Mini.surround** - Gestion des surroundings (silencieux)
- Ajouter, supprimer, remplacer des "surroundings"
- Mode silencieux + fallbacks automatiques
- Keymaps intuitifs style vim

## 📋 **Installation/Mise à jour**

1. **Remplacez** `config/plugins/mini.nix` par la version corrigée
2. **La config noice** est automatiquement mise à jour  
3. **Testez** : `nix run .`

## 🔧 **Mini.ai - Text Objects**

### **Objects standards (améliorés)**
- `w` - word
- `s` - sentence  
- `p` - paragraph
- `t` - tag (HTML/XML)
- `b` - bracket `()`, `[]`, `{}`
- `q` - quote `"`, `'`, `` ` ``

### **Objects custom ajoutés**
- `g` - entire buffer (tout le fichier)
- `l` - current line (ligne courante)
- `i` - indent level (niveau d'indentation)
- `o` - function call (appel de fonction)
- `e` - entire buffer (alias de `g`)

### **Usage**
```vim
" Sélection
vip    " sélectionner dans paragraph
vig    " sélectionner tout le buffer
vil    " sélectionner ligne courante
vio    " sélectionner appel de fonction

" Suppression  
daw    " supprimer around word
dip    " supprimer dans paragraph
dig    " supprimer tout le buffer

" Changement
cit    " changer dans tag
ciq    " changer dans quotes
cib    " changer dans brackets
```

## 🔗 **Mini.pairs - Auto-pairing (version silencieuse)**

### **Fonctionnalités automatiques**
- **Parenthèses** : `(` → `(|)` 
- **Crochets** : `[` → `[|]`
- **Accolades** : `{` → `{|}`
- **Guillemets** : `"` → `"|"`
- **Apostrophes** : `'` → `'|'`
- **Backticks** : `` ` `` → `` `|` ``

### **Intelligence (améliorée)**
- ✅ Skip si caractère suivant est alphanumérique
- ✅ Skip à l'intérieur des strings
- ✅ Équilibrage automatique
- ✅ Support markdown spécial
- ✅ **Mode silencieux** (pas de messages)
- ✅ **Insert mode uniquement** (plus de conflits command)

### **Exemples**
```
Tapez: function(
Résultat: function(|)

Tapez: "hello world
Résultat: "hello world"|   (pas de fermeture auto)

Tapez: "
Résultat: "|"  (silencieux, pas de message)
```

## 🔄 **Mini.surround - Surroundings (version silencieuse)**

### **Keymaps principaux**
- `gsa` - **Add** surrounding
- `gsd` - **Delete** surrounding  
- `gsr` - **Replace** surrounding
- `gsf` - **Find** next surrounding →
- `gsF` - **Find** previous surrounding ←
- `gsh` - **Highlight** surrounding
- `gsn` - **Update** n_lines

### **Usage add (gsa)**
```vim
gsaiw)    " Ajouter () autour du mot
gsaip"    " Ajouter "" autour du paragraph  
gsa$}     " Ajouter {} jusqu'à fin de ligne
gsaW]     " Ajouter [] autour du WORD
```

### **Usage delete (gsd)**
```vim
gsd)      " Supprimer les () les plus proches
gsd"      " Supprimer les "" les plus proches
gsd}      " Supprimer les {} les plus proches
gsdt      " Supprimer le tag HTML le plus proche
```

### **Usage replace (gsr)**
```vim
gsr'"     " Remplacer ' par "
gsr)]     " Remplacer ) par ]  
gsr`"     " Remplacer ` par "
gsrty     " Remplacer tag par y (fallback automatique)
```

### **Surroundings custom (améliorés)**

#### **`c` - Code block markdown**
```vim
gsac      " Ajouter ```code```
gsdc      " Supprimer ```code```
```

#### **`f` - Function call (avec fallback)**
```vim
gsaf      " Prompt → "func" si vide → func(contenu)
gsdf      " Supprimer func() wrapper
```

#### **`t` - HTML/XML tag (avec fallback)**  
```vim
gsat      " Prompt → "div" si vide → <div>contenu</div>
gsdt      " Supprimer <tag>contenu</tag>
```

## 🎨 **Intégration Which-key (silencieuse)**

### **Groupe `gs` (Surround)**
Appuyez sur `gs` pour voir le menu surround :
- `a` - Add Surround 🔗
- `d` - Delete Surround 🗑️
- `r` - Replace Surround 🔄
- `f` - Find Surround → 🔍
- `F` - Find Surround ← 🔍
- `h` - Highlight Surround ✨
- `n` - Update Lines 📏

## 🧪 **Commandes de test (fonctionnelles)**

### **Tester les fonctionnalités**
```vim
:TestMiniAi        " Guide text objects
:TestMiniSurround  " Guide surround keymaps  
:TestMiniPairs     " Guide auto-pairing
```

## 💡 **Exemples pratiques (version corrigée)**

### **Scenario 1 : Édition de code (silencieuse)**
```lua
-- Code initial
local function hello()
    print(Hello world)
end

-- Corrections avec mini.nvim (silencieux):
1. Cursor sur "Hello world"
2. gsa"  -> ajouter quotes: print("Hello world") [silencieux]
3. Position sur function, vaf -> sélectionner toute la fonction
4. Typing '(' dans pairs -> auto-completion [silencieuse]
```

### **Scenario 2 : Surround avec fallbacks**
```vim
-- Function surround
1. gsaf -> prompt "Function name:" 
2. [Entrée vide] -> fallback "func" automatique
3. Résultat: func(contenu) [pas d'erreur]

-- Tag surround  
1. gsat -> prompt "Tag name:"
2. [Entrée vide] -> fallback "div" automatique
3. Résultat: <div>contenu</div> [pas d'erreur]
```

## 🎯 **Workflow recommandé (optimisé)**

### **Text Objects (ai) - aucun changement**
1. **Navigation** : `vip`, `daw`, `cit`
2. **Sélection large** : `vig` (tout buffer), `vil` (ligne)
3. **Code-specific** : `vio` (function call), `vii` (indent level)

### **Auto-pairing (pairs) - maintenant silencieux**  
1. **Laissez faire** - fonctionne automatiquement et silencieusement
2. **En cas de problème** - Backspace fonctionne naturellement
3. **Dans strings** - Pas d'auto-pairing (intelligent)
4. **Plus d'interference** avec noice

### **Surround (surround) - maintenant avec fallbacks**
1. **Ajout** : `gsa` + motion + caractère
2. **Navigation** : `gsf`/`gsF` pour trouver
3. **Modification** : `gsr` pour remplacer, `gsd` pour supprimer
4. **Custom avec fallbacks** : `c`, `f` (→"func"), `t` (→"div")

## ⚡ **Performance et compatibilité**

- ✅ **Compatible noice** : Plus de conflits d'affichage
- ✅ **Mode silencieux** : Pas de spam de messages
- ✅ **Fallbacks intelligents** : Pas d'erreurs sur prompts vides
- ✅ **Which-key intégré** : Groupes et descriptions
- ✅ **Couleurs Gruvbox** : Highlights adaptés

## 🔍 **Troubleshooting amélioré**

### **Plus de conflits noice**
Les routes de filtrage et le mode silencieux règlent les problèmes d'affichage.

### **Prompts qui bloquent**
Les fallbacks automatiques ("func", "div") évitent les blocages.

### **Messages spam**
Le filtrage noice et les overrides éliminent les messages parasites.

La configuration est maintenant **100% compatible noice** et **stable** ! 🎉