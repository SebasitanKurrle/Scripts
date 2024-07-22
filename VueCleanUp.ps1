# Wechsel in das Projektverzeichnis
Set-Location -Path ".\"

# Entfernen der standardmäßigen Dateien und Verzeichnisse
Remove-Item -Path ".\src\assets" -Recurse -Force
New-Item -Path '.\src\assets' -ItemType Directory

Remove-Item -Path ".\src\components" -Recurse -Force
New-Item -Path '.\src\components' -ItemType Directory

Remove-Item -Path ".\src\views\AboutView.vue" -Recurse -Force
Remove-Item -Path ".\src\stores\counter.ts" -Recurse -Force

$appContent = @"
<script setup lang="ts">
import { RouterView } from "vue-router";
</script>

<template>
    <div class="container">
        <RouterView />
    </div>
</template>

<style scoped></style>
"@

$homeViewContent = @"
<script setup lang="ts">
</script>

<template>
    <div>
        <h1>HomeView</h1>
    </div>
</template>

<style scoped></style>
"@

$mainTSContent = @"
import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'

import "bootstrap/dist/css/bootstrap.min.css"

const app = createApp(App)

app.use(createPinia())
app.use(router)

app.mount('#app')
"@

$routerContent = @"
import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    }
  ]
})

export default router
"@

Remove-Item -Path ".\src\App.vue" -Recurse -Force
Set-Content -Path ".\src\App.vue" -Value $appContent

Remove-Item -Path ".\src\views\HomeView.vue" -Recurse -Force
Set-Content -Path ".\src\views\HomeView.vue" -Value $homeViewContent

Remove-Item -Path ".\src\main.ts" -Recurse -Force
Set-Content -Path ".\src\main.ts" -Value $mainTSContent

Remove-Item -Path ".\src\router\index.ts" -Recurse -Force
Set-Content -Path ".\src\router\index.ts" -Value $routerContent

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Error "npm ist nicht installiert. Bitte installiere Node.js und npm, bevor du fortfährst."
    exit 1
}

npm install
npm install bootstrap

if ($LASTEXITCODE -ne 0) {
    Write-Error "Fehler beim Installieren von Bootstrap."
    exit $LASTEXITCODE
} else {
    Write-Output "Bootstrap erfolgreich installiert."
}

# Bestätigen, dass die Dateien gelöscht wurden
Write-Output "Dateien wurden entfernt. Grundgerüst des Projekts ist nun leer."
