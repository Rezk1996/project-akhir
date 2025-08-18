import React, { useState, useRef, useEffect } from 'react';
import {
  Box,
  Button,
  Paper,
  Typography,
  Alert,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  CircularProgress,
  Chip,
} from '@mui/material';
import {
  CameraAlt,
  LocationOn,
  CheckCircle,
  Error,
  AccessTime,
} from '@mui/icons-material';

interface AttendanceSystemProps {
  onAttendanceSuccess: (data: any) => void;
  currentAttendanceStatus: 'none' | 'checked-in' | 'checked-out';
}

const AttendanceSystem: React.FC<AttendanceSystemProps> = ({ onAttendanceSuccess, currentAttendanceStatus }) => {
  const [open, setOpen] = useState(false);
  const [step, setStep] = useState<'location' | 'camera' | 'processing' | 'success'>('location');
  const [attendanceType, setAttendanceType] = useState<'check-in' | 'check-out'>('check-in');
  const [location, setLocation] = useState<{ lat: number; lng: number } | null>(null);
  const [locationError, setLocationError] = useState('');
  const [photo, setPhoto] = useState<string | null>(null);
  const [isInWorkArea, setIsInWorkArea] = useState(false);
  const [loading, setLoading] = useState(false);
  
  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const streamRef = useRef<MediaStream | null>(null);

  // Koordinat Rehan Print & Fotocopy
  const OFFICE_LOCATION = {
    lat: -5.4960487,
    lng: 120.1289206,
    radius: 100 // 100 meter radius
  };

  const calculateDistance = (lat1: number, lng1: number, lat2: number, lng2: number) => {
    const R = 6371e3; // Earth's radius in meters
    const φ1 = lat1 * Math.PI/180;
    const φ2 = lat2 * Math.PI/180;
    const Δφ = (lat2-lat1) * Math.PI/180;
    const Δλ = (lng2-lng1) * Math.PI/180;

    const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

    return R * c;
  };

  const getCurrentLocation = () => {
    setLoading(true);
    setLocationError('');

    if (!navigator.geolocation) {
      setLocationError('Geolocation tidak didukung browser ini');
      setLoading(false);
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        const { latitude, longitude } = position.coords;
        setLocation({ lat: latitude, lng: longitude });
        
        const distance = calculateDistance(
          latitude, longitude,
          OFFICE_LOCATION.lat, OFFICE_LOCATION.lng
        );
        
        if (distance <= OFFICE_LOCATION.radius) {
          setIsInWorkArea(true);
          setStep('camera');
        } else {
          setIsInWorkArea(false);
          setLocationError(`Anda berada ${Math.round(distance)}m dari Rehan Print & Fotocopy. Harus dalam radius ${OFFICE_LOCATION.radius}m untuk absen`);
        }
        setLoading(false);
      },
      (error) => {
        setLocationError('Gagal mendapatkan lokasi. Pastikan GPS aktif dan izinkan akses lokasi.');
        setLoading(false);
      },
      { enableHighAccuracy: true, timeout: 10000, maximumAge: 60000 }
    );
  };

  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ 
        video: { facingMode: 'user' },
        audio: false 
      });
      
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        streamRef.current = stream;
      }
    } catch (error) {
      setLocationError('Gagal mengakses kamera. Pastikan izinkan akses kamera.');
    }
  };

  const takePicture = () => {
    if (videoRef.current && canvasRef.current) {
      const canvas = canvasRef.current;
      const video = videoRef.current;
      
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      
      const ctx = canvas.getContext('2d');
      if (ctx) {
        ctx.drawImage(video, 0, 0);
        const photoData = canvas.toDataURL('image/jpeg', 0.8);
        setPhoto(photoData);
        
        // Stop camera
        if (streamRef.current) {
          streamRef.current.getTracks().forEach(track => track.stop());
        }
        
        processAttendance(photoData);
      }
    }
  };

  const processAttendance = async (photoData: string) => {
    setStep('processing');
    
    // Simulate processing
    setTimeout(() => {
      const attendanceData = {
        timestamp: new Date().toISOString(),
        location: location,
        photo: photoData,
        status: 'success',
        type: attendanceType
      };
      
      setStep('success');
      onAttendanceSuccess(attendanceData);
      
      setTimeout(() => {
        handleClose();
      }, 2000);
    }, 2000);
  };

  const handleClose = () => {
    setOpen(false);
    setStep('location');
    setLocation(null);
    setLocationError('');
    setPhoto(null);
    setIsInWorkArea(false);
    setLoading(false);
    
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
    }
  };
  
  const handleOpenAttendance = (type: 'check-in' | 'check-out') => {
    setAttendanceType(type);
    setOpen(true);
  };

  useEffect(() => {
    if (step === 'camera') {
      startCamera();
    }
  }, [step]);

  const renderLocationStep = () => (
    <Box textAlign="center">
      <LocationOn sx={{ fontSize: 60, color: '#667eea', mb: 2 }} />
      <Typography variant="h6" gutterBottom>
        {attendanceType === 'check-in' ? 'Absen Masuk' : 'Absen Keluar'} - Verifikasi Lokasi
      </Typography>
      <Typography variant="body2" color="textSecondary" sx={{ mb: 3 }}>
        Pastikan Anda berada di area Rehan Print & Fotocopy untuk melakukan {attendanceType === 'check-in' ? 'absen masuk' : 'absen keluar'}
      </Typography>
      
      {locationError && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {locationError}
        </Alert>
      )}
      
      {location && (
        <Box sx={{ mb: 2 }}>
          <Chip 
            icon={<LocationOn />}
            label={`${location.lat.toFixed(6)}, ${location.lng.toFixed(6)}`}
            color={isInWorkArea ? 'success' : 'error'}
            sx={{ mb: 1 }}
          />
          <Typography variant="caption" display="block">
            {isInWorkArea ? '✅ Lokasi Valid - Rehan Print & Fotocopy' : '❌ Di Luar Area Rehan Print & Fotocopy'}
          </Typography>
        </Box>
      )}
      
      <Button
        variant="contained"
        onClick={getCurrentLocation}
        disabled={loading}
        sx={{
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          '&:hover': { background: 'linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%)' }
        }}
      >
        {loading ? <CircularProgress size={24} color="inherit" /> : 'Cek Lokasi'}
      </Button>
    </Box>
  );

  const renderCameraStep = () => (
    <Box textAlign="center">
      <Typography variant="h6" gutterBottom>
        {attendanceType === 'check-in' ? 'Absen Masuk' : 'Absen Keluar'} - Ambil Foto Selfie
      </Typography>
      <Typography variant="body2" color="textSecondary" sx={{ mb: 2 }}>
        Posisikan wajah Anda di tengah kamera untuk {attendanceType === 'check-in' ? 'absen masuk' : 'absen keluar'}
      </Typography>
      
      <Box sx={{ position: 'relative', mb: 2 }}>
        <video
          ref={videoRef}
          autoPlay
          playsInline
          style={{
            width: '100%',
            maxWidth: '300px',
            borderRadius: '12px',
            transform: 'scaleX(-1)' // Mirror effect
          }}
        />
        <canvas ref={canvasRef} style={{ display: 'none' }} />
      </Box>
      
      <Button
        variant="contained"
        startIcon={<CameraAlt />}
        onClick={takePicture}
        sx={{
          background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
          '&:hover': { background: 'linear-gradient(135deg, #3b82f6 0%, #06b6d4 100%)' }
        }}
      >
        Ambil Foto
      </Button>
    </Box>
  );

  const renderProcessingStep = () => (
    <Box textAlign="center">
      <CircularProgress size={60} sx={{ color: '#667eea', mb: 2 }} />
      <Typography variant="h6" gutterBottom>
        Memproses {attendanceType === 'check-in' ? 'Absen Masuk' : 'Absen Keluar'}...
      </Typography>
      <Typography variant="body2" color="textSecondary">
        Mohon tunggu sebentar
      </Typography>
    </Box>
  );

  const renderSuccessStep = () => (
    <Box textAlign="center">
      <CheckCircle sx={{ fontSize: 60, color: '#4CAF50', mb: 2 }} />
      <Typography variant="h6" gutterBottom color="success.main">
        {attendanceType === 'check-in' ? 'Absen Masuk' : 'Absen Keluar'} Berhasil!
      </Typography>
      <Typography variant="body2" color="textSecondary">
        Terima kasih, {attendanceType === 'check-in' ? 'absen masuk' : 'absen keluar'} Anda telah tercatat
      </Typography>
    </Box>
  );

  return (
    <>
      <Box sx={{ display: 'flex', gap: 1, flexDirection: 'column' }}>
        {currentAttendanceStatus === 'none' || currentAttendanceStatus === 'checked-out' ? (
          <Button
            variant="contained"
            startIcon={<AccessTime />}
            onClick={() => handleOpenAttendance('check-in')}
            sx={{
              background: 'linear-gradient(135deg, #4CAF50 0%, #8BC34A 100%)',
              color: 'white',
              fontWeight: 600,
              px: 3,
              py: 1.5,
              borderRadius: 2,
              boxShadow: '0 4px 15px rgba(76, 175, 80, 0.4)',
              '&:hover': {
                background: 'linear-gradient(135deg, #388E3C 0%, #689F38 100%)',
                transform: 'translateY(-2px)',
                boxShadow: '0 6px 20px rgba(76, 175, 80, 0.6)'
              },
              transition: 'all 0.3s ease'
            }}
          >
            Absen Masuk
          </Button>
        ) : null}
        
        {currentAttendanceStatus === 'checked-in' ? (
          <Button
            variant="contained"
            startIcon={<AccessTime />}
            onClick={() => handleOpenAttendance('check-out')}
            sx={{
              background: 'linear-gradient(135deg, #FF5722 0%, #FF9800 100%)',
              color: 'white',
              fontWeight: 600,
              px: 3,
              py: 1.5,
              borderRadius: 2,
              boxShadow: '0 4px 15px rgba(255, 87, 34, 0.4)',
              '&:hover': {
                background: 'linear-gradient(135deg, #D84315 0%, #F57C00 100%)',
                transform: 'translateY(-2px)',
                boxShadow: '0 6px 20px rgba(255, 87, 34, 0.6)'
              },
              transition: 'all 0.3s ease'
            }}
          >
            Absen Keluar
          </Button>
        ) : null}
      </Box>

      <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
        <DialogTitle sx={{ textAlign: 'center', pb: 1 }}>
          <Typography variant="h5" sx={{ fontWeight: 600 }}>
            {attendanceType === 'check-in' ? 'Sistem Absen Masuk' : 'Sistem Absen Keluar'}
          </Typography>
        </DialogTitle>
        
        <DialogContent sx={{ py: 3 }}>
          {step === 'location' && renderLocationStep()}
          {step === 'camera' && renderCameraStep()}
          {step === 'processing' && renderProcessingStep()}
          {step === 'success' && renderSuccessStep()}
        </DialogContent>
        
        {step !== 'processing' && step !== 'success' && (
          <DialogActions>
            <Button onClick={handleClose}>
              Batal
            </Button>
          </DialogActions>
        )}
      </Dialog>
    </>
  );
};

export default AttendanceSystem;