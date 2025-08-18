import React, { useState, useRef } from 'react';
import {
  Box,
  Button,
  TextField,
  Tabs,
  Tab,
  IconButton,
  Typography,
  Paper
} from '@mui/material';
import {
  CloudUpload,
  Link as LinkIcon,
  Delete,
  Add
} from '@mui/icons-material';

interface ImageUploadProps {
  images: string[];
  onImagesChange: (images: string[]) => void;
}

const ImageUpload: React.FC<ImageUploadProps> = ({ images, onImagesChange }) => {
  const [tabValue, setTabValue] = useState(0);
  const [imageUrls, setImageUrls] = useState<string[]>(['']);
  const [isDragging, setIsDragging] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (files) {
      Array.from(files).forEach(file => {
        const reader = new FileReader();
        reader.onload = (event) => {
          if (event.target?.result) {
            onImagesChange([...images, event.target.result as string]);
          }
        };
        reader.readAsDataURL(file);
      });
    }
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const handleUrlChange = (index: number, value: string) => {
    const newUrls = [...imageUrls];
    newUrls[index] = value;
    setImageUrls(newUrls);
  };

  const addUrlField = () => {
    setImageUrls([...imageUrls, '']);
  };

  const removeUrlField = (index: number) => {
    setImageUrls(imageUrls.filter((_, i) => i !== index));
  };

  const addUrlsToImages = () => {
    const validUrls = imageUrls.filter(url => url.trim() !== '');
    if (validUrls.length > 0) {
      onImagesChange([...images, ...validUrls]);
      setImageUrls(['']);
    }
  };

  const removeImage = (index: number) => {
    onImagesChange(images.filter((_, i) => i !== index));
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(true);
  };

  const handleDragLeave = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
  };

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setIsDragging(false);
    
    const files = Array.from(e.dataTransfer.files).filter(file => 
      file.type.startsWith('image/')
    );
    
    files.forEach(file => {
      const reader = new FileReader();
      reader.onload = (event) => {
        if (event.target?.result) {
          onImagesChange([...images, event.target.result as string]);
        }
      };
      reader.readAsDataURL(file);
    });
  };

  return (
    <Box>
      <Tabs value={tabValue} onChange={(_, newValue) => setTabValue(newValue)}>
        <Tab icon={<CloudUpload />} label="Upload Files" />
        <Tab icon={<LinkIcon />} label="Image URLs" />
      </Tabs>

      {tabValue === 0 && (
        <Box sx={{ mt: 2 }}>
          <input
            ref={fileInputRef}
            type="file"
            multiple
            accept="image/*"
            onChange={handleFileUpload}
            style={{ display: 'none' }}
          />
          <Button
            variant="outlined"
            startIcon={<CloudUpload />}
            onClick={() => fileInputRef.current?.click()}
            onDragOver={handleDragOver}
            onDragLeave={handleDragLeave}
            onDrop={handleDrop}
            fullWidth
            sx={{ 
              p: 3, 
              border: isDragging ? '2px dashed #4CAF50' : '2px dashed #007AFF',
              backgroundColor: isDragging ? 'rgba(76, 175, 80, 0.1)' : 'rgba(0, 122, 255, 0.05)',
              '&:hover': {
                backgroundColor: 'rgba(0, 122, 255, 0.1)'
              },
              transition: 'all 0.3s ease'
            }}
          >
            <Box textAlign="center">
              <Typography variant="h6" color={isDragging ? "#4CAF50" : "#007AFF"}>
                {isDragging ? 'Drop Images Here' : 'Click to Upload or Drag & Drop'}
              </Typography>
              <Typography variant="body2" color="textSecondary">
                {isDragging ? 'Release to upload images' : 'Select multiple images from your device or drag them here'}
              </Typography>
            </Box>
          </Button>
        </Box>
      )}

      {tabValue === 1 && (
        <Box sx={{ mt: 2 }}>
          {imageUrls.map((url, index) => (
            <Box key={index} sx={{ display: 'flex', gap: 1, mb: 2 }}>
              <TextField
                fullWidth
                label={`Image URL ${index + 1}`}
                value={url}
                onChange={(e) => handleUrlChange(index, e.target.value)}
                placeholder="https://example.com/image.jpg"
              />
              {imageUrls.length > 1 && (
                <IconButton onClick={() => removeUrlField(index)} color="error">
                  <Delete />
                </IconButton>
              )}
            </Box>
          ))}
          <Box sx={{ display: 'flex', gap: 1 }}>
            <Button
              startIcon={<Add />}
              onClick={addUrlField}
              variant="outlined"
            >
              Add URL
            </Button>
            <Button
              onClick={addUrlsToImages}
              variant="contained"
              disabled={!imageUrls.some(url => url.trim() !== '')}
            >
              Add to Images
            </Button>
          </Box>
        </Box>
      )}

      {images.length > 0 && (
        <Box sx={{ mt: 3 }}>
          <Typography variant="h6" gutterBottom>
            Selected Images ({images.length})
          </Typography>
          <Box sx={{ 
            display: 'grid', 
            gridTemplateColumns: 'repeat(auto-fill, minmax(120px, 1fr))', 
            gap: 2 
          }}>
            {images.map((image, index) => (
              <Paper key={index} sx={{ position: 'relative', p: 1 }}>
                <img
                  src={image}
                  alt={`Product ${index + 1}`}
                  style={{
                    width: '100%',
                    height: 120,
                    objectFit: 'cover',
                    borderRadius: 4
                  }}
                />
                <IconButton
                  onClick={() => removeImage(index)}
                  sx={{
                    position: 'absolute',
                    top: -10,
                    right: -10,
                    backgroundColor: '#f44336',
                    color: 'white',
                    width: 30,
                    height: 30,
                    '&:hover': {
                      backgroundColor: '#d32f2f'
                    }
                  }}
                >
                  <Delete fontSize="small" />
                </IconButton>
              </Paper>
            ))}
          </Box>
        </Box>
      )}
    </Box>
  );
};

export default ImageUpload;