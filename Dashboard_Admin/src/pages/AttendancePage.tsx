import React, { useEffect, useState } from 'react';
import {
  Box,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
  Chip,
  Grid,
  Card,
  CardContent,
  TextField,
  MenuItem,
  Button,
} from '@mui/material';
import {
  CheckCircle,
  Cancel,
  Schedule,
  TrendingUp,
} from '@mui/icons-material';
import { employeeService } from '../services/api';

interface AttendanceRecord {
  id: number;
  employee_id: number;
  employee_name: string;
  date: string;
  check_in_time: string;
  check_out_time: string;
  work_hours: number;
  status: string;
  notes: string;
}

const AttendancePage: React.FC = () => {
  const [attendance, setAttendance] = useState<AttendanceRecord[]>([]);
  const [employees, setEmployees] = useState<any[]>([]);
  const [selectedMonth, setSelectedMonth] = useState(new Date().getMonth() + 1);
  const [selectedYear, setSelectedYear] = useState(new Date().getFullYear());
  const [selectedEmployee, setSelectedEmployee] = useState('');
  const [stats, setStats] = useState({
    totalPresent: 0,
    totalAbsent: 0,
    totalLate: 0,
    avgWorkHours: 0,
  });

  useEffect(() => {
    loadAttendance();
    loadEmployees();
  }, [selectedMonth, selectedYear, selectedEmployee]);

  const loadAttendance = async () => {
    try {
      const params = {
        month: selectedMonth,
        year: selectedYear,
        employee_id: selectedEmployee || undefined,
      };
      const response = await employeeService.getAttendance(params);
      if (response.status) {
        const attendanceData = response.data.attendance || [];
        setAttendance(attendanceData);
        
        // Calculate stats
        const present = attendanceData.filter((a: AttendanceRecord) => a.status === 'present').length;
        const absent = attendanceData.filter((a: AttendanceRecord) => a.status === 'absent').length;
        const late = attendanceData.filter((a: AttendanceRecord) => a.status === 'late').length;
        const avgHours = attendanceData.reduce((sum: number, a: AttendanceRecord) => sum + (a.work_hours || 0), 0) / attendanceData.length || 0;
        
        setStats({
          totalPresent: present,
          totalAbsent: absent,
          totalLate: late,
          avgWorkHours: avgHours,
        });
      }
    } catch (error) {
      console.error('Error loading attendance:', error);
    }
  };

  const loadEmployees = async () => {
    try {
      const response = await employeeService.getEmployees();
      if (response.status) {
        setEmployees(response.data.employees || []);
      }
    } catch (error) {
      console.error('Error loading employees:', error);
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'present': return 'success';
      case 'absent': return 'error';
      case 'late': return 'warning';
      case 'half_day': return 'info';
      default: return 'default';
    }
  };

  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'present': return <CheckCircle />;
      case 'absent': return <Cancel />;
      case 'late': return <Schedule />;
      default: return <CheckCircle />;
    }
  };

  const months = [
    { value: 1, label: 'January' },
    { value: 2, label: 'February' },
    { value: 3, label: 'March' },
    { value: 4, label: 'April' },
    { value: 5, label: 'May' },
    { value: 6, label: 'June' },
    { value: 7, label: 'July' },
    { value: 8, label: 'August' },
    { value: 9, label: 'September' },
    { value: 10, label: 'October' },
    { value: 11, label: 'November' },
    { value: 12, label: 'December' },
  ];

  const years = Array.from({ length: 5 }, (_, i) => new Date().getFullYear() - 2 + i);

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
          Attendance Management
        </Typography>
        <Typography variant="body1" sx={{ color: '#4a5568', fontSize: '1.1rem' }}>
          Track and manage employee attendance records
        </Typography>
      </Box>

      {/* Filters */}
      <Paper sx={{ p: 3, mb: 3, borderRadius: 3 }}>
        <Grid container spacing={2} alignItems="center">
          <Grid item xs={12} md={3}>
            <TextField
              fullWidth
              select
              label="Month"
              value={selectedMonth}
              onChange={(e) => setSelectedMonth(Number(e.target.value))}
            >
              {months.map((month) => (
                <MenuItem key={month.value} value={month.value}>
                  {month.label}
                </MenuItem>
              ))}
            </TextField>
          </Grid>
          <Grid item xs={12} md={3}>
            <TextField
              fullWidth
              select
              label="Year"
              value={selectedYear}
              onChange={(e) => setSelectedYear(Number(e.target.value))}
            >
              {years.map((year) => (
                <MenuItem key={year} value={year}>
                  {year}
                </MenuItem>
              ))}
            </TextField>
          </Grid>
          <Grid item xs={12} md={4}>
            <TextField
              fullWidth
              select
              label="Employee"
              value={selectedEmployee}
              onChange={(e) => setSelectedEmployee(e.target.value)}
            >
              <MenuItem value="">All Employees</MenuItem>
              {employees.map((employee) => (
                <MenuItem key={employee.id} value={employee.id}>
                  {employee.nama} ({employee.employee_id})
                </MenuItem>
              ))}
            </TextField>
          </Grid>
          <Grid item xs={12} md={2}>
            <Button
              fullWidth
              variant="contained"
              onClick={loadAttendance}
              sx={{
                background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                '&:hover': { background: 'linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%)' }
              }}
            >
              Filter
            </Button>
          </Grid>
        </Grid>
      </Paper>

      {/* Statistics Cards */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Card sx={{ 
            background: 'linear-gradient(135deg, #4CAF50 0%, #8BC34A 100%)',
            color: 'white'
          }}>
            <CardContent sx={{ textAlign: 'center' }}>
              <CheckCircle sx={{ fontSize: 40, mb: 1 }} />
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                {stats.totalPresent}
              </Typography>
              <Typography variant="body2">
                Present Days
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card sx={{ 
            background: 'linear-gradient(135deg, #F44336 0%, #E57373 100%)',
            color: 'white'
          }}>
            <CardContent sx={{ textAlign: 'center' }}>
              <Cancel sx={{ fontSize: 40, mb: 1 }} />
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                {stats.totalAbsent}
              </Typography>
              <Typography variant="body2">
                Absent Days
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card sx={{ 
            background: 'linear-gradient(135deg, #FF9800 0%, #FFB74D 100%)',
            color: 'white'
          }}>
            <CardContent sx={{ textAlign: 'center' }}>
              <Schedule sx={{ fontSize: 40, mb: 1 }} />
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                {stats.totalLate}
              </Typography>
              <Typography variant="body2">
                Late Days
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card sx={{ 
            background: 'linear-gradient(135deg, #2196F3 0%, #64B5F6 100%)',
            color: 'white'
          }}>
            <CardContent sx={{ textAlign: 'center' }}>
              <TrendingUp sx={{ fontSize: 40, mb: 1 }} />
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                {stats.avgWorkHours.toFixed(1)}
              </Typography>
              <Typography variant="body2">
                Avg Work Hours
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Attendance Table */}
      <TableContainer component={Paper} sx={{ borderRadius: 3 }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Date</TableCell>
              <TableCell>Employee</TableCell>
              <TableCell>Check In</TableCell>
              <TableCell>Check Out</TableCell>
              <TableCell>Work Hours</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Notes</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {attendance.map((record) => (
              <TableRow key={record.id}>
                <TableCell>
                  {new Date(record.date).toLocaleDateString('id-ID', {
                    weekday: 'short',
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric'
                  })}
                </TableCell>
                <TableCell>{record.employee_name}</TableCell>
                <TableCell>{record.check_in_time || '-'}</TableCell>
                <TableCell>{record.check_out_time || '-'}</TableCell>
                <TableCell>{record.work_hours ? `${record.work_hours}h` : '-'}</TableCell>
                <TableCell>
                  <Chip 
                    icon={getStatusIcon(record.status)}
                    label={record.status.replace('_', ' ').toUpperCase()} 
                    color={getStatusColor(record.status) as any}
                    size="small" 
                  />
                </TableCell>
                <TableCell>{record.notes || '-'}</TableCell>
              </TableRow>
            ))}
            {attendance.length === 0 && (
              <TableRow>
                <TableCell colSpan={7} align="center">
                  <Typography variant="body2" color="textSecondary">
                    No attendance records found for the selected period
                  </Typography>
                </TableCell>
              </TableRow>
            )}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};

export default AttendancePage;