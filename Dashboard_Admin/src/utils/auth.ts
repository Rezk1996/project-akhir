export const clearAuthData = () => {
  localStorage.removeItem('admin_token');
  localStorage.removeItem('admin_user');
  localStorage.removeItem('login_date');
};

export const initializeAuth = () => {
  // Check if login is from today, if not clear auth data
  const loginDate = localStorage.getItem('login_date');
  const today = new Date().toDateString();
  
  if (loginDate !== today) {
    clearAuthData();
  }
};

export const setLoginDate = () => {
  const today = new Date().toDateString();
  localStorage.setItem('login_date', today);
};