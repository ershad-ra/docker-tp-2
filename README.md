# Docker TP 2 - `Docker Application Express JS`
## 1. Compléter le `Dockerfile `
### Compléter le `Dockerfile` afin de builder correctement l’application contenu dans `srv/`
- Chaque instruction a un rôle précis pour construire une image Docker:
```bash
# Utiliser une image légère de Node.js
FROM node:12-alpine3.9

# Définir le dossier de travail
WORKDIR /app

# Copier uniquement package.json pour optimiser le cache
COPY package.json ./

# Installer les dépendances de production uniquement
RUN npm install --only=production

# Copier le reste des fichiers du projet
COPY . .

# Exposer le port utilisé par Express.js
EXPOSE 3000

# Démarrer l’application
CMD ["node", "srv/index.js"]

```
### Explication pour chaque ligne :
### Choisir l’image de base : `FROM node:12-alpine3.9`
- Que fait cette ligne ?
`FROM` → Définit l’image de base sur laquelle on va construire l’image Docker.  
`node:12-alpine3.9 `→ Utilise `Node.js` version` 12 `basée sur `Alpine` Linux, qui est très légère et optimisée.  
- Pourquoi `Alpine` ?
Image plus petite (moins de 10 Mo au lieu de 300 Mo pour `Debian`). Moins de ressources utilisées.
### Définir un répertoire de travail : `WORKDIR /app`
- Que fait cette ligne ?
`WORKDIR /app` → Définit le répertoire de travail dans le conteneur.  
Toutes les commandes suivantes (comme `COPY`, `RUN`, `CMD`) s’exécuteront à l’intérieur de `/app`.
- Pourquoi utiliser `WORKDIR` ?
Assure que tout le code et les dépendances seront dans `/app` et pas ailleurs.  
Évite d’écrire `cd /app` dans chaque commande.
### Copier uniquement `package.json` pour optimiser le cache : `COPY package.json ./`
- Que fait cette ligne ?
`COPY package.json ./` → Copie `package.json` dans `/app` (défini par `WORKDIR`).  
`./` signifie "copie à la racine du répertoire de travail (`/app`)".
- Pourquoi copier `package.json` avant tout le reste ?
Docker garde en cache les étapes de construction.  
Si on copie tout avant d’installer les dépendances, chaque modification dans un fichier (même un petit changement dans `index.js`) obligera Docker à réinstaller toutes les dépendances.  
En copiant d’abord `package.json`, Docker peut réutiliser le cache pour accélérer la construction.

### Installer uniquement les dépendances de production : `RUN npm install --only=production`
- Que fait cette ligne ?
`RUN` → Exécute une commande pendant la construction de l’image.  
`npm install --only=production` → Installe seulement les dépendances de production (exclut `devDependencies`).
- Pourquoi `--only=production` ?
Les dépendances de développement ne sont pas nécessaires en production.  
Cela réduit la taille de l’image et accélère le lancement.

### Copier le reste des fichiers : `COPY . . `
- Que fait cette ligne ?
`COPY . . `→ Copie tout ce qui est dans le projet vers `/app` dans le conteneur.
- Pourquoi ne pas faire ça dès le début ?
Si `package.json` ne change pas, Docker peut utiliser le cache et éviter de réinstaller les dépendances.  
Cette approche accélère la construction.

### Exposer le port utilisé par Express.js : `EXPOSE 3000`
 - Que fait cette ligne ?
`EXPOSE 3000 `→ Informe Docker que le conteneur utilise le port` 3000`.  
`Express.js` écoute sur ce port (`PORT=3000` dans `index.js`).
- Est-ce obligatoire ?
Non, mais c'est une bonne pratique.  
Il faudra quand même publier le port via `docker run -p 3000:3000`.

### Définir la commande de lancement : `CMD ["node", "srv/index.js"]`
- Que fait cette ligne ?
`CMD` → Définit la commande principale exécutée lorsque le conteneur démarre.  
`["node", "srv/index.js"] `→ Lance `Node.js `et exécute `index.js `qui est dans le dossier `srv/`.
- Pourquoi `CMD` et pas `RUN `?
`RUN` → S’exécute lors de la construction de l’image.  
`CMD` → S’exécute chaque fois qu’on lance le conteneur.

## 2. Créer un image avec le `Dockerfile`
### Se placer dans le dossier contenant le `Dockerfile`, puis exécuter :
```bash
docker build -t ma_super_app .
```

- `docker build` → Lance la construction de l’image.  
- `-t ma_super_app` → Donne le nom `ma_super_app` à l’image (au lieu d’un ID généré).  
- `. `→ Indique que le `Dockerfile` est dans le dossier courant.

### Après la construction, vérifie si l’image existe bien :
```bash
docker images
```
### Maintenant que l’image est prête, on peut créer et exécuter un conteneur :

```bash
docker run -d --name mon_app -p 3000:3000 ma_super_app

```
### L’application tourne maintenant sur` http://localhost:3000` !

### Les commandes utils:
```bash
docker ps
docker ps -a
docker logs mon_app
docker stop mon_app
docker rm mon_app
docker rmi ma_super_app # Pour supprimer l'image aussi
```