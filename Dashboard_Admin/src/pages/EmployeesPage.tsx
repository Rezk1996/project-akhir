import React, { useEffect, useState } from 'react';
import {
  Box,
  Button,
  Paper,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  MenuItem,
  Chip,
  Avatar,
  Grid,
  Card,
  CardContent,
} from '@mui/material';
import {
  Add,
  Edit,
  Delete,
  Visibility,
  Person,
  Work,
  AttachMoney,
  Schedule,
} from '@mui/icons-material';
import { employeeService } from '../services/api';

interface Employee {
  id: number;
  employee_id: string;
  nama: string;
  position: string;
  department: string;
  hire_date: string;
  salary: number;
  phone: string;
  status: string;
  shift_id: number;
  nama_shift?: string;
  email?: string;
  years_of_service?: number;
}

const EmployeesPage: React.FC = () => {
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [open, setOpen] = useState(false);
  const [viewOpen, setViewOpen] = useState(false);
  const [editingEmployee, setEditingEmployee] = useState<Employee | null>(null);
  const [selectedEmployee, setSelectedEmployee] = useState<Employee | null>(null);
  const [shifts, setShifts] = useState<any[]>([]);
  const [stats, setStats] = useState({
    totalEmployees: 0,
    activeEmployees: 0,
    totalSalary: 0,
    avgSalary: 0,
  });
  const [formData, setFormData] = useState({
    employee_id: '',
    nama: '',
    position: '',
    department: '',
    hire_date: '',
    salary: '',
    phone: '',
    shift_id: '',
    status: 'active',
  });

  useEffect(() => {
    loadEmployees();
    loadShifts();
  }, []);

  const loadEmployees = async () => {
    try {
      const response = await employeeService.getEmployees();
      if (response.status) {
        const employeeData = response.data.employees || [];
        setEmployees(employeeData);
        
        // Calculate stats
        const total = employeeData.length;
        const active = employeeData.filter((emp: Employee) => emp.status === 'active').length;
        const totalSalary = employeeData.reduce((sum: number, emp: Employee) => sum + (emp.salary || 0), 0);
        
        setStats({
          totalEmployees: total,
          activeEmployees: active,
          totalSalary,
          avgSalary: total > 0 ? totalSalary / total : 0,
        });
      }
    } catch (error) {
      console.error('Error loading employees:', error);
    }
  };

  const loadShifts = async () => {
    try {
      const response = await employeeService.getShifts();
      if (response.status) {
        setShifts(response.data.shifts || []);
      }
    } catch (error) {
      console.error('Error loading shifts:', error);
    }
  };

  const handleOpen = (employee?: Employee) => {
    if (employee) {
      setEditingEmployee(employee);
      setFormData({
        employee_id: employee.employee_id,
        nama: employee.nama,
        position: employee.position,
        department: employee.department,
        hire_date: employee.hire_date,
        salary: employee.salary.toString(),
        phone: employee.phone || '',
        shift_id: employee.shift_id?.toString() || '',
        status: employee.status,
      });
    } else {
      setEditingEmployee(null);
      setFormData({
        employee_id: '',
        nama: '',
        position: '',
        department: '',
        hire_date: '',
        salary: '',
        phone: '',
        shift_id: '',
        status: 'active',
      });
    }
    setOpen(true);
  };

  const handleView = (employee: Employee) => {
    setSelectedEmployee(employee);
    setViewOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
    setViewOpen(false);
    setEditingEmployee(null);
    setSelectedEmployee(null);
  };

  const handleSubmit = async () => {
    try {
      const employeeData = {
        ...formData,
        salary: parseFloat(formData.salary),
        shift_id: parseInt(formData.shift_id),
      };

      let response;
      if (editingEmployee) {
        response = await employeeService.updateEmployee(editingEmployee.id, employeeData);
      } else {
        response = await employeeService.createEmployee(employeeData);
      }

      if (response.status) {
        loadEmployees();
        handleClose();
      } else {
        alert('Error: ' + (response.message || 'Failed to save employee'));
      }
    } catch (error: any) {
      console.error('Error saving employee:', error);
      alert('Error saving employee: ' + (error.response?.data?.message || error.message));
    }
  };

  const handleDelete = async (id: number) => {
    if (window.confirm('Are you sure you want to delete this employee?')) {
      try {
        const response = await employeeService.deleteEmployee(id);
        if (response.status) {
          loadEmployees();
        } else {
          alert('Failed to delete employee: ' + (response.message || 'Unknown error'));
        }
      } catch (error: any) {
        console.error('Error deleting employee:', error);
        alert('Error deleting employee: ' + (error.response?.data?.message || error.message));
      }
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active': return 'success';
      case 'inactive': return 'error';
      case 'suspended': return 'warning';
      default: return 'default';
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
          Employee Management
        </Typography>
        <Typography variant="body1" sx={{ color: '#4a5568', fontSize: '1.1rem' }}>
          Manage employee data, attendance, and payroll
        </Typography>
      </Box>

      {/* Statistics Cards */}
      <Grid container spacing={3} sx={{ mb: 4 }}>
        <Grid item xs={12} sm={6} md={3}>
          <Card sx={{ 
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            color: 'white'
          }}>
            <CardContent sx={{ textAlign: 'center' }}>
              <Person sx={{ fontSize: 40, mb: 1 }} />
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                {stats.totalEmployees}
              </Typography>
              <Typography variant="body2">
                Total Employees
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card sx={{ 
            background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)',
            color: 'white'
          }}>
            <CardContent sx={{ textAlign: 'center' }}>
              <Work sx={{ fontSize: 40, mb: 1 }} />
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                {stats.activeEmployees}
              </Typography>
              <Typography variant="body2">
                Active Employees
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card sx={{ 
            background: 'linear-gradient(135deg, #fa709a 0%, #fee140 100%)',
            color: 'white'
          }}>
            <CardContent sx={{ textAlign: 'center' }}>
              <AttachMoney sx={{ fontSize: 40, mb: 1 }} />
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                {(stats.avgSalary / 1000000).toFixed(1)}M
              </Typography>
              <Typography variant="body2">
                Avg Salary (IDR)
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={3}>
          <Card sx={{ 
            background: 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)',
            color: 'white'
          }}>
            <CardContent sx={{ textAlign: 'center' }}>
              <Schedule sx={{ fontSize: 40, mb: 1 }} />
              <Typography variant="h4" sx={{ fontWeight: 700 }}>
                {shifts.length}
              </Typography>
              <Typography variant="body2">
                Work Shifts
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      <Box display="flex" justifyContent="space-between" alignItems="center" mb={3}>
        <Typography variant="h5" sx={{ fontWeight: 600 }}>
          Employee List
        </Typography>
        <Button
          variant="contained"
          startIcon={<Add />}
          onClick={() => handleOpen()}
          sx={{
            background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            '&:hover': { background: 'linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%)' }
          }}
        >
          Add Employee
        </Button>
      </Box>

      <TableContainer component={Paper} sx={{ borderRadius: 3 }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell>Employee ID</TableCell>
              <TableCell>Name</TableCell>
              <TableCell>Position</TableCell>
              <TableCell>Department</TableCell>
              <TableCell>Salary</TableCell>
              <TableCell>Status</TableCell>
              <TableCell>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {employees.map((employee) => (
              <TableRow key={employee.id}>
                <TableCell>
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
                    <Avatar sx={{ width: 32, height: 32, bgcolor: '#667eea' }}>
                      {employee.nama.charAt(0)}
                    </Avatar>
                    {employee.employee_id}
                  </Box>
                </TableCell>
                <TableCell>{employee.nama}</TableCell>
                <TableCell>{employee.position}</TableCell>
                <TableCell>{employee.department}</TableCell>
                <TableCell>Rp {employee.salary?.toLocaleString()}</TableCell>
                <TableCell>
                  <Chip 
                    label={employee.status} 
                    color={getStatusColor(employee.status) as any}
                    size="small" 
                  />
                </TableCell>
                <TableCell>
                  <IconButton onClick={() => handleView(employee)} color="info">
                    <Visibility />
                  </IconButton>
                  <IconButton onClick={() => handleOpen(employee)} color="primary">
                    <Edit />
                  </IconButton>
                  <IconButton onClick={() => handleDelete(employee.id)} color="error">
                    <Delete />
                  </IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>

      {/* Add/Edit Dialog */}
      <Dialog open={open} onClose={handleClose} maxWidth="md" fullWidth>
        <DialogTitle>
          {editingEmployee ? 'Edit Employee' : 'Add New Employee'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Employee ID"
                value={formData.employee_id}
                onChange={(e) => setFormData({ ...formData, employee_id: e.target.value })}
                required
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Full Name"
                value={formData.nama}
                onChange={(e) => setFormData({ ...formData, nama: e.target.value })}
                required
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Position"
                value={formData.position}
                onChange={(e) => setFormData({ ...formData, position: e.target.value })}
                required
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Department"
                value={formData.department}
                onChange={(e) => setFormData({ ...formData, department: e.target.value })}
                required
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Hire Date"
                type="date"
                value={formData.hire_date}
                onChange={(e) => setFormData({ ...formData, hire_date: e.target.value })}
                InputLabelProps={{ shrink: true }}
                required
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Salary (IDR)"
                type="number"
                value={formData.salary}
                onChange={(e) => setFormData({ ...formData, salary: e.target.value })}
                required
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                label="Phone"
                value={formData.phone}
                onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                fullWidth
                select
                label="Work Shift"
                value={formData.shift_id}
                onChange={(e) => setFormData({ ...formData, shift_id: e.target.value })}
                required
              >
                {shifts.map((shift) => (
                  <MenuItem key={shift.id} value={shift.id}>
                    {shift.nama_shift} ({shift.jam_mulai} - {shift.jam_selesai})
                  </MenuItem>
                ))}
              </TextField>
            </Grid>
            <Grid item xs={12}>
              <TextField
                fullWidth
                select
                label="Status"
                value={formData.status}
                onChange={(e) => setFormData({ ...formData, status: e.target.value })}
              >
                <MenuItem value="active">Active</MenuItem>
                <MenuItem value="inactive">Inactive</MenuItem>
                <MenuItem value="suspended">Suspended</MenuItem>
              </TextField>
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Cancel</Button>
          <Button 
            onClick={handleSubmit} 
            variant="contained"
            sx={{
              background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
              '&:hover': { background: 'linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%)' }
            }}
          >
            {editingEmployee ? 'Update' : 'Create'}
          </Button>
        </DialogActions>
      </Dialog>

      {/* View Dialog */}
      <Dialog open={viewOpen} onClose={handleClose} maxWidth="sm" fullWidth>
        <DialogTitle>Employee Details</DialogTitle>
        <DialogContent>
          {selectedEmployee && (
            <Box sx={{ pt: 2 }}>
              <Grid container spacing={2}>
                <Grid item xs={12} textAlign="center">
                  <Avatar sx={{ 
                    width: 80, 
                    height: 80, 
                    bgcolor: '#667eea',
                    mx: 'auto',
                    mb: 2,
                    fontSize: '2rem'
                  }}>
                    {selectedEmployee.nama.charAt(0)}
                  </Avatar>
                  <Typography variant="h5" gutterBottom>
                    {selectedEmployee.nama}
                  </Typography>
                  <Chip 
                    label={selectedEmployee.status} 
                    color={getStatusColor(selectedEmployee.status) as any}
                  />
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="textSecondary">Employee ID</Typography>
                  <Typography variant="body1">{selectedEmployee.employee_id}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="textSecondary">Position</Typography>
                  <Typography variant="body1">{selectedEmployee.position}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="textSecondary">Department</Typography>
                  <Typography variant="body1">{selectedEmployee.department}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="textSecondary">Hire Date</Typography>
                  <Typography variant="body1">
                    {new Date(selectedEmployee.hire_date).toLocaleDateString('id-ID')}
                  </Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="textSecondary">Salary</Typography>
                  <Typography variant="body1">Rp {selectedEmployee.salary?.toLocaleString()}</Typography>
                </Grid>
                <Grid item xs={6}>
                  <Typography variant="body2" color="textSecondary">Work Shift</Typography>
                  <Typography variant="body1">{selectedEmployee.nama_shift || 'N/A'}</Typography>
                </Grid>
                {selectedEmployee.phone && (
                  <Grid item xs={12}>
                    <Typography variant="body2" color="textSecondary">Phone</Typography>
                    <Typography variant="body1">{selectedEmployee.phone}</Typography>
                  </Grid>
                )}
                {selectedEmployee.years_of_service && (
                  <Grid item xs={12}>
                    <Typography variant="body2" color="textSecondary">Years of Service</Typography>
                    <Typography variant="body1">{selectedEmployee.years_of_service} years</Typography>
                  </Grid>
                )}
              </Grid>
            </Box>
          )}
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>Close</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default EmployeesPage;