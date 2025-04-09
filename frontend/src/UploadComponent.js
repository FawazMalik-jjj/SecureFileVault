import React, { useState } from 'react';
import axios from 'axios';

function Upload() {
  const [file, setFile] = useState(null);

  const handleUpload = async (e) => {
    e.preventDefault();
    const formData = new FormData();
    formData.append('file', file);
    
    try {
      await axios.post('https://api.yourdomain.com/upload', formData, {
        headers: {
          'X-User-ID': 'user123',
          'Content-Type': 'multipart/form-data'
        }
      });
      alert('File uploaded securely!');
    } catch (error) {
      alert('Upload failed: ' + error.message);
    }
  };

  return (
    <form onSubmit={handleUpload}>
      <input type="file" onChange={(e) => setFile(e.target.files[0])} />
      <button type="submit">Upload</button>
    </form>
  );
}

export default Upload;