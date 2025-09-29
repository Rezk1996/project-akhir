// Debug script to check profile update issue
console.log('=== PROFILE UPDATE DEBUG ===');

// Check current localStorage data
const token = localStorage.getItem('token');
const user = localStorage.getItem('user');

console.log('Token:', token);
console.log('User:', user);

if (token) {
    console.log('Token length:', token.length);
    
    if (token.startsWith('session_')) {
        const parts = token.split('_');
        console.log('Token parts:', parts);
        console.log('User ID from token:', parts[1]);
    }
}

if (user) {
    try {
        const userData = JSON.parse(user);
        console.log('Parsed user data:', userData);
        console.log('User ID:', userData.id);
        console.log('User email:', userData.email);
    } catch (e) {
        console.log('Error parsing user data:', e);
    }
}

// Function to test profile update
function testProfileUpdate() {
    const token = localStorage.getItem('token');
    if (!token) {
        console.log('No token found');
        return;
    }
    
    const formData = new FormData();
    formData.append('name', 'Test Name');
    formData.append('email', 'test@update.com');
    formData.append('phone', '123456789');
    formData.append('address', 'Test Address');
    
    fetch('http://localhost:8191/api/auth/profile', {
        method: 'PUT',
        headers: {
            'Authorization': `Bearer ${token}`
        },
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        console.log('Update response:', data);
    })
    .catch(error => {
        console.log('Update error:', error);
    });
}

console.log('Run testProfileUpdate() to test profile update');