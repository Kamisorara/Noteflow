<template>
  <div class="login-container">
    <n-card class="login-card" title="卡片" :border="false" size="large">
      <!-- 头部 -->
      <div class="login-title">
        NoteFlow 登陆
      </div>
      <!-- 内容 -->
      <n-from :model="form" :rules="loginRules" ref="LoginFormRef">
        <n-form-item label="用户名" path="username">
          <n-input v-model:value="form.username" placeholder="请输入用户名" />
        </n-form-item>
        <n-form-item label="密码" path="password">
          <n-input type="password" v-model:value="form.password" show-password-on="mousedown" placeholder="请输入密码" />
        </n-form-item>
        <n-form-item>
          <n-button type="primary" block @click="handleLogin" :loading="loading">登 录</n-button>
        </n-form-item>
      </n-from>
    </n-card>
  </div>
</template>

<script setup lang='ts'>
import { ref, reactive, computed } from 'vue';
import { useMessage, darkTheme } from 'naive-ui';

const LoginFormRef = ref();
const form = reactive({
  username: '',
  password: ''
});

const loginRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
}

const loading = ref(false);
const message = useMessage();

const handleLogin = async () => {
  await LoginFormRef.value?.validate();
  loading.value = true;
  setTimeout(() => {
    loading.value = false;
    message.success('登陆成功');
  }, 2000);

}

</script>
<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f7f8fa;
  color-scheme: light dark;
  background: var(--login-bg, #f7f8fa);
  transition: background 0.3s;
}

.login-card {
  width: 340px;
  box-shadow: 0 4px 24px 0 rgba(0, 0, 0, 0.06);
  border-radius: 16px;
  padding: 32px 24px;
  background: var(--card-bg, #fff);
  transition: background 0.3s;
}

.login-title {
  font-size: 1.6rem;
  font-weight: 600;
  text-align: center;
  margin-bottom: 32px;
  color: #222;
  letter-spacing: 2px;
}

/* 深色模式适配 */
@media (prefers-color-scheme: dark) {
  .login-container {
    --login-bg: #1e1e1e;
  }

  .login-card {
    --card-bg: #232324;
  }

  .login-title {
    --title-color: #fff;
  }
}
</style>