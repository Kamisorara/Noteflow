<template>
  <n-config-provider>
    <n-message-provider>
      <LoginPage />
    </n-message-provider>
  </n-config-provider>
</template>

<script setup lang="ts">
import { NConfigProvider, NMessageProvider } from 'naive-ui'
import LoginPage from './pages/LoginPage.vue';
</script>

<style scoped></style>
