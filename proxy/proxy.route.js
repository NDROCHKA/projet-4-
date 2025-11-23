import express from 'express';

const router = express.Router();

router.get('/', async (req, res) => {
  const { url } = req.query;

  if (!url) {
    return res.status(400).send('URL is required');
  }

  console.log('Proxying image request for:', url);

  try {
    const response = await fetch(url);

    if (!response.ok) {
      return res.status(response.status).send('Failed to fetch image');
    }


    // Forward the content type
    const contentType = response.headers.get('content-type');
    if (contentType) {
      res.setHeader('Content-Type', contentType);
    }

    // Add CORS headers explicitly
    res.setHeader('Access-Control-Allow-Origin', '*');

    // Pipe the response body to the client
    // response.body is a ReadableStream in standard fetch, but in Node 22+ it should be compatible
    // However, to be safe with Express, we can convert to buffer or use stream
    const arrayBuffer = await response.arrayBuffer();
    const buffer = Buffer.from(arrayBuffer);
    res.send(buffer);

  } catch (error) {
    console.error('Proxy error:', error);
    res.status(500).send('Error fetching image');
  }
});

export default router;
