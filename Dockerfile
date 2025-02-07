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