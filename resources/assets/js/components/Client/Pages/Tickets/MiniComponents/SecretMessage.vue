<template>
  <alert componentName="secret-message-model"></alert>
  <div class="card">
    <h2 class="section-title h4 clearfix mb-0 lineOrg">{{ lang('decrypted_content') }}</h2>
    <div class="ms-3">
      <PreviewContent :decryptedMessage="decryptedMessage" :contentType="contentType" />
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import * as openpgp from 'openpgp';
import axios from 'axios';
import CryptoJS from 'crypto-js';

import { errorHandler } from '../../../../../helpers/responseHandler';
import { lang } from "../../../../../helpers/extraLogics";
import PreviewContent from "../../../../Common/PreviewContent.vue";

export default {
  name: 'SecretMessage',
  components: {PreviewContent},
  setup() {
    const route = useRoute(); // Use useRoute to access route parameters
    const decryptedMessage = ref('');
    const contentType = ref('text');
    const secretKey = ref('');
    const decryptedCipher = ref('');
    const privateKeyArmored = ref('');
    const newKey = ref('');

    const decryptMessage = async () => {
      await getSecretMessage();
      const passphrase = 'vks9fODlRcTdQdftGJSSIw';
      try {
        const privateKey = await openpgp.readPrivateKey({ armoredKey: decryptedCipher.value });
        const decryptedPrivateKey = await openpgp.decryptKey({ privateKey, passphrase });
        const message = await openpgp.readMessage({ armoredMessage: secretKey.value });
        const res = await openpgp.decrypt({ message, decryptionKeys: decryptedPrivateKey, format: 'utf8' });

        const content = res.data;
        // Use the refactored content type determination
        contentType.value = determineContentType(content);
        decryptedMessage.value = content;
      } catch (error) {
        console.error(error);
      }
    };

    // Refactored content type determination logic
    const determineContentType = (content) => {
      const contentTypes = {
        'data:image/': 'image',
        'data:application/pdf': 'pdf',
        'data:text/csv': 'csv',
        'data:text/plain': 'filetext',
        'data:application/json': 'json',
        'data:application/zip': 'zip',
        'data:application/x-rar-compressed': 'rar',
        'data:application/msword': 'doc',
        'data:application/vnd.openxmlformats-officedocument.wordprocessingml.document': 'docx',
        'data:application/vnd.ms-excel': 'xls',
        'data:application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'xlsx',
        'data:application/vnd.ms-powerpoint': 'ppt',
        'data:application/vnd.openxmlformats-officedocument.presentationml.presentation': 'pptx',
        'data:text/sql': 'sql'
      };

      for (const prefix in contentTypes) {
        if (content.startsWith(prefix)) {
          return contentTypes[prefix];
        }
      }

      return 'text';
    };

    const getSecretMessage = async () => {
      try {
        const response = await axios.get(`secret/secret-messages/show/${newKey.value}`);
        secretKey.value = response.data.data.secret_messages;
        privateKeyArmored.value = response.data.data.messageKey;
        getCipherKey();
      } catch (error) {
        secretKey.value = '';
        privateKeyArmored.value = '';
        decryptedCipher.value = '';
        decryptedMessage.value = '';
        errorHandler(error, 'secret-message-model');
      }
    };

    const getCipherKey = () => {
      const password = 'uJELGmwsyWIZP6yiA';
      const bytes = CryptoJS.AES.decrypt(privateKeyArmored.value, password);
      decryptedCipher.value = bytes.toString(CryptoJS.enc.Utf8);
    };

    onMounted(() => {
      newKey.value = route.params.id; // Access route parameter using route.params
      decryptMessage();
    });

    return {
      decryptedMessage,
      contentType,
      lang
    };
  }
};
</script>

<style scoped>
.lineOrg {
  margin: 15px !important;
}
</style>
