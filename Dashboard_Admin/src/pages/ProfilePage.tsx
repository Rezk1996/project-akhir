import React, { useState, useEffect } from 'react';
import {
  Box,
  Paper,
  Typography,
  Avatar,
  Grid,
  Card,
  CardContent,
  Chip,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Divider,
  LinearProgress,
} from '@mui/material';
import {
  Person,
  Work,
  Timeline,
  TrendingUp,
  Add,
  Edit,
  Delete,
  Category,
  Inventory,
  Assessment,
  CheckCircle,
} from '@mui/icons-material';
import { authService } from '../services/api';
import AttendanceSystem from '../components/AttendanceSystem';

interface ActivityLog {
  id: number;
  action: string;
  target: string;
  description: string;
  timestamp: string;
  icon: React.ReactNode;
  color: string;
}

const ProfilePage: React.FC = () => {
  const [user] = useState(authService.getCurrentUser());
  const [workDuration, setWorkDuration] = useState('');
  const [activities, setActivities] = useState<ActivityLog[]>([]);
  const [stats, setStats] = useState({
    productsAdded: 12,
    categoriesManaged: 8,
    ordersProcessed: 45,
    systemUpdates: 23,
  });
  const [attendanceHistory, setAttendanceHistory] = useState<any[]>([]);
  const [currentAttendanceStatus, setCurrentAttendanceStatus] = useState<'none' | 'checked-in' | 'checked-out'>('none');

  useEffect(() => {
    // Calculate work duration
    const startDate = new Date('2024-01-15'); // Mock start date
    const now = new Date();
    const diffTime = Math.abs(now.getTime() - startDate.getTime());
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    const months = Math.floor(diffDays / 30);
    const days = diffDays % 30;
    setWorkDuration(`${months} bulan ${days} hari`);

    // Mock activity logs
    setActivities([
      {
        id: 1,
        action: 'Added Product',
        target: 'Aqua Botol 600ml',
        description: 'Menambahkan produk baru ke kategori Minuman',
        timestamp: '2 jam yang lalu',
        icon: <Add />,
        color: '#4CAF50',
      },
      {
        id: 2,
        action: 'Updated Category',
        target: 'Personal Care',
        description: 'Mengubah icon dan warna kategori Personal Care',
        timestamp: '5 jam yang lalu',
        icon: <Edit />,
        color: '#2196F3',
      },
      {
        id: 3,
        action: 'Deleted Product',
        target: 'Produk Test',
        description: 'Menghapus produk test dari sistem',
        timestamp: '1 hari yang lalu',
        icon: <Delete />,
        color: '#F44336',
      },
      {
        id: 4,
        action: 'Created Category',
        target: 'Pet Foods',
        description: 'Membuat kategori baru untuk produk makanan hewan',
        timestamp: '2 hari yang lalu',
        icon: <Category />,
        color: '#9C27B0',
      },
      {
        id: 5,
        action: 'Updated Dashboard',
        target: 'Analytics View',
        description: 'Memperbarui tampilan analytics dashboard',
        timestamp: '3 hari yang lalu',
        icon: <Assessment />,
        color: '#FF9800',
      },
      {
        id: 6,
        action: 'Bulk Import',
        target: '15 Products',
        description: 'Import massal 15 produk dari supplier baru',
        timestamp: '1 minggu yang lalu',
        icon: <Inventory />,
        color: '#607D8B',
      },
    ]);
    
    // Mock attendance history
    setAttendanceHistory([
      {
        id: 1,
        date: '2025-01-12',
        checkIn: '08:30',
        checkOut: '17:15',
        status: 'present',
        location: 'Rehan Print & Fotocopy'
      },
      {
        id: 2,
        date: '2025-01-11',
        checkIn: '08:45',
        checkOut: '17:30',
        status: 'present',
        location: 'Rehan Print & Fotocopy'
      },
      {
        id: 3,
        date: '2025-01-10',
        checkIn: '09:00',
        checkOut: '17:00',
        status: 'late',
        location: 'Rehan Print & Fotocopy'
      }
    ]);
  }, []);
  
  const handleAttendanceSuccess = (attendanceData: any) => {
    const currentTime = new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' });
    const today = new Date().toISOString().split('T')[0];
    
    if (attendanceData.type === 'check-in') {
      // Check In
      const newAttendance = {
        id: attendanceHistory.length + 1,
        date: today,
        checkIn: currentTime,
        checkOut: '-',
        status: 'present',
        location: 'Rehan Print & Fotocopy'
      };
      
      setAttendanceHistory(prev => [newAttendance, ...prev.filter(item => item.date !== today)]);
      setCurrentAttendanceStatus('checked-in');
      
      // Add to activity log
      const newActivity = {
        id: activities.length + 1,
        action: 'Absen Masuk',
        target: 'Rehan Print & Fotocopy',
        description: `Melakukan absen masuk pada ${currentTime} dengan verifikasi lokasi dan selfie`,
        timestamp: 'Baru saja',
        icon: <CheckCircle />,
        color: '#4CAF50',
      };
      
      setActivities(prev => [newActivity, ...prev]);
      
    } else if (attendanceData.type === 'check-out') {
      // Check Out
      setAttendanceHistory(prev => 
        prev.map(item => 
          item.date === today 
            ? { ...item, checkOut: currentTime }
            : item
        )
      );
      setCurrentAttendanceStatus('checked-out');
      
      // Add to activity log
      const newActivity = {
        id: activities.length + 1,
        action: 'Absen Keluar',
        target: 'Rehan Print & Fotocopy',
        description: `Melakukan absen keluar pada ${currentTime} dengan verifikasi lokasi dan selfie`,
        timestamp: 'Baru saja',
        icon: <CheckCircle />,
        color: '#FF5722',
      };
      
      setActivities(prev => [newActivity, ...prev]);
    }
  };

  return (
    <Box>
      <Box sx={{ mb: 4 }}>
        <Typography 
          variant="h4" 
          gutterBottom 
          sx={{ 
            fontWeight: 700,
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            backgroundClip: 'text',
            WebkitBackgroundClip: 'text',
            WebkitTextFillColor: 'transparent',
            mb: 1
          }}
        >
          Profile Karyawan
        </Typography>
        <Typography variant="body1" sx={{ color: '#4a5568', fontSize: '1.1rem' }}>
          Informasi identitas dan aktivitas karyawan
        </Typography>
      </Box>

      <Grid container spacing={3}>
        {/* Profile Card */}
        <Grid item xs={12} md={4}>
          <Paper sx={{ 
            p: 3, 
            borderRadius: 3,
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            color: 'white',
            textAlign: 'center'
          }}>
            <Avatar
              sx={{
                width: 100,
                height: 100,
                mx: 'auto',
                mb: 2,
                bgcolor: 'rgba(255,255,255,0.2)',
                fontSize: '2rem',
                fontWeight: 'bold'
              }}
            >
              {user?.name?.charAt(0)}
            </Avatar>
            <Typography variant="h5" gutterBottom sx={{ fontWeight: 600 }}>
              {user?.name || 'Administrator'}
            </Typography>
            <Typography variant="body1" sx={{ opacity: 0.9, mb: 2 }}>
              {user?.email || 'admin@rmart.com'}
            </Typography>
            <Chip 
              label="Admin Manager" 
              sx={{ 
                bgcolor: 'rgba(255,255,255,0.2)', 
                color: 'white',
                fontWeight: 600
              }} 
            />
          </Paper>

          {/* Work Info */}
          <Paper sx={{ 
            p: 3, 
            mt: 2,
            borderRadius: 3,
            background: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
          }}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
              <Work sx={{ color: '#667eea', mr: 1 }} />
              <Typography variant="h6" sx={{ fontWeight: 600 }}>
                Informasi Kerja
              </Typography>
            </Box>
            <Typography variant="body2" color="textSecondary" gutterBottom>
              Posisi: Admin Manager
            </Typography>
            <Typography variant="body2" color="textSecondary" gutterBottom>
              Departemen: IT & Operations
            </Typography>
            <Typography variant="body2" color="textSecondary" gutterBottom>
              Lama Bekerja: {workDuration}
            </Typography>
            <Typography variant="body2" color="textSecondary">
              Status: Aktif
            </Typography>
          </Paper>
          
          {/* Attendance System */}
          <Paper sx={{ 
            p: 3, 
            mt: 2,
            borderRadius: 3,
            background: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
            textAlign: 'center'
          }}>
            <Typography variant="h6" sx={{ fontWeight: 600, mb: 2 }}>
              Sistem Absen
            </Typography>
            <AttendanceSystem 
              onAttendanceSuccess={handleAttendanceSuccess} 
              currentAttendanceStatus={currentAttendanceStatus}
            />
            
            <Box sx={{ mt: 2 }}>
              <Typography variant="body2" color="textSecondary" gutterBottom>
                Riwayat Absen Hari Ini:
              </Typography>
              {attendanceHistory.length > 0 && attendanceHistory[0].date === new Date().toISOString().split('T')[0] ? (
                <Box sx={{ 
                  bgcolor: currentAttendanceStatus === 'checked-in' ? '#e8f5e8' : 
                           currentAttendanceStatus === 'checked-out' ? '#fff3e0' : '#f5f5f5',
                  p: 1.5,
                  borderRadius: 1,
                  mt: 1
                }}>
                  <Typography variant="body2" sx={{ fontWeight: 500 }}>
                    Masuk: {attendanceHistory[0].checkIn}
                  </Typography>
                  {attendanceHistory[0].checkOut !== '-' && (
                    <Typography variant="body2" sx={{ fontWeight: 500 }}>
                      Keluar: {attendanceHistory[0].checkOut}
                    </Typography>
                  )}
                  <Typography variant="caption" color="textSecondary">
                    Status: {currentAttendanceStatus === 'checked-in' ? 'Sedang Bekerja' : 
                             currentAttendanceStatus === 'checked-out' ? 'Sudah Pulang' : 'Belum Absen'}
                  </Typography>
                </Box>
              ) : (
                <Box sx={{ 
                  bgcolor: '#f5f5f5',
                  p: 1.5,
                  borderRadius: 1,
                  mt: 1
                }}>
                  <Typography variant="body2" sx={{ fontWeight: 500 }}>
                    Belum absen hari ini
                  </Typography>
                </Box>
              )}
            </Box>
          </Paper>
        </Grid>

        {/* Statistics */}
        <Grid item xs={12} md={8}>
          <Grid container spacing={2} sx={{ mb: 3 }}>
            <Grid item xs={6} md={3}>
              <Card sx={{ 
                background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
                color: 'white'
              }}>
                <CardContent sx={{ textAlign: 'center' }}>
                  <Inventory sx={{ fontSize: 40, mb: 1 }} />
                  <Typography variant="h4" sx={{ fontWeight: 700 }}>
                    {stats.productsAdded}
                  </Typography>
                  <Typography variant="body2">
                    Produk Ditambahkan
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={6} md={3}>
              <Card sx={{ 
                background: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
                color: 'white'
              }}>
                <CardContent sx={{ textAlign: 'center' }}>
                  <Category sx={{ fontSize: 40, mb: 1 }} />
                  <Typography variant="h4" sx={{ fontWeight: 700 }}>
                    {stats.categoriesManaged}
                  </Typography>
                  <Typography variant="body2">
                    Kategori Dikelola
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={6} md={3}>
              <Card sx={{ 
                background: 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)',
                color: 'white'
              }}>
                <CardContent sx={{ textAlign: 'center' }}>
                  <TrendingUp sx={{ fontSize: 40, mb: 1 }} />
                  <Typography variant="h4" sx={{ fontWeight: 700 }}>
                    {stats.ordersProcessed}
                  </Typography>
                  <Typography variant="body2">
                    Order Diproses
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
            <Grid item xs={6} md={3}>
              <Card sx={{ 
                background: 'linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%)',
                color: 'white'
              }}>
                <CardContent sx={{ textAlign: 'center' }}>
                  <Assessment sx={{ fontSize: 40, mb: 1 }} />
                  <Typography variant="h4" sx={{ fontWeight: 700 }}>
                    {stats.systemUpdates}
                  </Typography>
                  <Typography variant="body2">
                    Update Sistem
                  </Typography>
                </CardContent>
              </Card>
            </Grid>
          </Grid>

          {/* Activity Log */}
          <Paper sx={{ 
            p: 3,
            borderRadius: 3,
            background: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
          }}>
            <Box sx={{ display: 'flex', alignItems: 'center', mb: 3 }}>
              <Timeline sx={{ color: '#667eea', mr: 1 }} />
              <Typography variant="h6" sx={{ fontWeight: 600 }}>
                Aktivitas Terbaru
              </Typography>
            </Box>
            
            <List>
              {activities.map((activity, index) => (
                <React.Fragment key={activity.id}>
                  <ListItem sx={{ px: 0 }}>
                    <ListItemIcon>
                      <Avatar sx={{ 
                        bgcolor: activity.color, 
                        width: 40, 
                        height: 40 
                      }}>
                        {activity.icon}
                      </Avatar>
                    </ListItemIcon>
                    <ListItemText
                      primary={
                        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                          <Typography variant="subtitle1" sx={{ fontWeight: 600 }}>
                            {activity.action}
                          </Typography>
                          <Chip 
                            label={activity.target} 
                            size="small" 
                            sx={{ 
                              bgcolor: `${activity.color}20`,
                              color: activity.color,
                              fontWeight: 500
                            }}
                          />
                        </Box>
                      }
                      secondary={
                        <Box>
                          <Typography variant="body2" color="textSecondary">
                            {activity.description}
                          </Typography>
                          <Typography variant="caption" color="textSecondary">
                            {activity.timestamp}
                          </Typography>
                        </Box>
                      }
                    />
                  </ListItem>
                  {index < activities.length - 1 && <Divider />}
                </React.Fragment>
              ))}
            </List>
          </Paper>
          
          {/* Attendance History */}
          <Paper sx={{ 
            p: 3, 
            mt: 2,
            borderRadius: 3,
            background: 'rgba(255,255,255,0.9)',
            backdropFilter: 'blur(10px)',
          }}>
            <Typography variant="h6" sx={{ fontWeight: 600, mb: 2 }}>
              Riwayat Absen (7 Hari Terakhir)
            </Typography>
            
            <List>
              {attendanceHistory.slice(0, 7).map((record, index) => (
                <React.Fragment key={record.id}>
                  <ListItem sx={{ px: 0 }}>
                    <ListItemIcon>
                      <CheckCircle sx={{ 
                        color: record.status === 'present' ? '#4CAF50' : 
                               record.status === 'late' ? '#FF9800' : '#F44336'
                      }} />
                    </ListItemIcon>
                    <ListItemText
                      primary={
                        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                          <Typography variant="subtitle2">
                            {new Date(record.date).toLocaleDateString('id-ID', { 
                              weekday: 'long', 
                              year: 'numeric', 
                              month: 'long', 
                              day: 'numeric' 
                            })}
                          </Typography>
                          <Chip 
                            label={record.status === 'present' ? 'Hadir' : 
                                   record.status === 'late' ? 'Terlambat' : 'Tidak Hadir'}
                            size="small"
                            color={record.status === 'present' ? 'success' : 
                                   record.status === 'late' ? 'warning' : 'error'}
                          />
                        </Box>
                      }
                      secondary={
                        <Typography variant="body2" color="textSecondary">
                          Masuk: {record.checkIn} | Keluar: {record.checkOut} | {record.location}
                        </Typography>
                      }
                    />
                  </ListItem>
                  {index < Math.min(attendanceHistory.length - 1, 6) && <Divider />}
                </React.Fragment>
              ))}
            </List>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
};

export default ProfilePage;