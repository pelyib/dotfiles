import { createServer, IncomingMessage, ServerResponse } from 'http';

const PORT = process.env.PORT || 3000;

const server = createServer((req: IncomingMessage, res: ServerResponse) => {
  const timestamp = new Date().toISOString();

  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(`${timestamp}\nnode-js`);
});

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
