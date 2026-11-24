require('dotenv').config();
const app = require('./app');
const { PORT } = require('./config/env');

app.listen(PORT, () => {
  console.log(`\n🚀 LoanNova Backend v2.0`);
  console.log(`   Listening on http://localhost:${PORT}`);
  console.log(`   Health check: http://localhost:${PORT}/api/health\n`);
});
