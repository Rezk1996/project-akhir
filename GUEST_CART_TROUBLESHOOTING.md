# 🔧 Guest Cart Troubleshooting Guide

## 🚨 Common Issue: Cart Empty After Login

### Problem Description
User adds items to cart as guest, then logs in, but cart becomes empty instead of syncing the guest items.

### Root Causes & Solutions

#### 1. **Timing Issues**
**Problem**: Cart sync happens before user state is fully updated
**Solution**: Added multiple event triggers with delays
```javascript
// In AuthContext - after successful login
setTimeout(() => {
  window.dispatchEvent(new CustomEvent('cartSyncRequired'));
}, 200);
```

#### 2. **localStorage Key Conflicts**
**Problem**: Using different keys for guest cart storage/retrieval
**Solution**: Simplified to use single 'guestCart' key
```javascript
// Simplified approach
const cartKey = 'guestCart';
localStorage.setItem(cartKey, JSON.stringify(cartItems));
```

#### 3. **State Management Race Conditions**
**Problem**: Multiple useEffect hooks competing
**Solution**: Proper dependency management and async handling
```javascript
useEffect(() => {
  const syncAndLoad = async () => {
    await syncGuestCartToUser();
    await loadUserCart();
    await loadCartCount();
  };
  if (isAuthenticated && user) {
    syncAndLoad();
  }
}, [isAuthenticated, user]);
```

## 🧪 Testing Steps

### Manual Testing Process

#### Step 1: Test Guest Cart
1. Open browser (incognito mode recommended)
2. Go to http://localhost:3000
3. Add 2-3 products to cart
4. Verify cart badge shows correct count
5. Check localStorage: `localStorage.getItem('guestCart')`

#### Step 2: Test Login Sync
1. With items in guest cart, click login
2. Login with existing account
3. Verify cart items appear after login
4. Check that guest cart is cleared: `localStorage.getItem('guestCart')`

#### Step 3: Test Persistence
1. Add items as guest
2. Close browser completely
3. Reopen and navigate to site
4. Verify items are still in cart

### Debug Commands

#### Browser Console Commands
```javascript
// Check guest cart
console.log('Guest Cart:', localStorage.getItem('guestCart'));

// Check auth state
console.log('User:', localStorage.getItem('user'));
console.log('Token:', localStorage.getItem('token'));

// Check all cart-related keys
Object.keys(localStorage).filter(key => key.includes('cart'));

// Clear guest cart
localStorage.removeItem('guestCart');

// Trigger manual sync (when logged in)
window.dispatchEvent(new CustomEvent('cartSyncRequired'));
```

#### Network Tab Monitoring
Monitor these API calls during login:
- `POST /api/auth/login` - Should return user data
- `POST /api/cart/add` - Should be called for each guest cart item
- `GET /api/cart` - Should return synced cart

## 🔍 Debug Logging

### Enable Detailed Logging
The CartContext includes extensive console logging. Look for these key messages:

```
✅ Good Flow:
- "Adding to guest cart: [product]"
- "Guest cart saved successfully"
- "syncGuestCartToUser: Guest items to sync: [items]"
- "Successfully synced item: [item name]"
- "Sync completed successfully"

❌ Problem Indicators:
- "No guest cart found"
- "Guest cart is empty"
- "Error syncing guest cart"
- "Cart cleared completely" (when not expected)
```

## 🛠️ Quick Fixes

### Fix 1: Force Cart Sync
```javascript
// In browser console after login
window.dispatchEvent(new CustomEvent('cartSyncRequired'));
```

### Fix 2: Manual Cart Recovery
```javascript
// If you know what was in the cart
const recoveredItems = [
  { id: 1, productId: 1, name: "Product 1", price: 25000, quantity: 1, image: "img1.jpg", stock: 100 }
];
localStorage.setItem('guestCart', JSON.stringify(recoveredItems));
window.location.reload();
```

### Fix 3: Clear All Cart Data
```javascript
// Nuclear option - clear everything
localStorage.removeItem('guestCart');
localStorage.removeItem('guestCartTimestamp');
Object.keys(localStorage).forEach(key => {
  if (key.startsWith('guestCart_')) {
    localStorage.removeItem(key);
  }
});
window.location.reload();
```

## 🔧 Backend Considerations

### Ensure Cart API Works
Test these endpoints manually:

```bash
# Add item to cart (authenticated)
curl -X POST http://localhost:8191/api/cart/add \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"productId": 1, "quantity": 1}'

# Get cart items
curl -X GET http://localhost:8191/api/cart \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Database Check
```sql
-- Check if cart items are being saved
SELECT * FROM cart_items WHERE user_id = YOUR_USER_ID;

-- Check product availability
SELECT id, name, stock FROM products WHERE id IN (1,2,3);
```

## 📊 Monitoring & Analytics

### Key Metrics to Track
- Guest cart creation rate
- Login conversion rate from guest cart
- Cart sync success rate
- Cart abandonment after login

### Error Tracking
Monitor these errors in production:
- "Error syncing guest cart"
- "Failed to add product to cart"
- "Cart sync timeout"

## 🚀 Performance Optimization

### Reduce Sync Time
- Batch cart item additions
- Use Promise.all for parallel API calls
- Implement retry logic for failed syncs

### Improve User Experience
- Show loading indicator during sync
- Display success message after sync
- Handle partial sync failures gracefully

## 📞 Support Scenarios

### User Reports Empty Cart After Login

1. **Immediate Response**:
   - Ask user to check browser console for errors
   - Verify they had items before login
   - Check if they're using incognito/private mode

2. **Investigation Steps**:
   - Check server logs for cart API calls
   - Verify user authentication is working
   - Test with same browser/device if possible

3. **Resolution**:
   - Guide user through manual cart recovery
   - Offer compensation if items were lost
   - Document issue for development team

### Bulk Cart Sync Issues

If multiple users report the same issue:
1. Check server status and API health
2. Review recent code deployments
3. Monitor error rates in logging system
4. Consider temporary rollback if critical

---

## 🎯 Prevention Checklist

- ✅ Test guest cart in multiple browsers
- ✅ Test with different network conditions
- ✅ Verify localStorage persistence
- ✅ Test login/logout cycles
- ✅ Monitor API response times
- ✅ Implement proper error boundaries
- ✅ Add user feedback mechanisms
- ✅ Document all edge cases

Remember: Guest cart sync is a critical user experience feature. When in doubt, prioritize user data preservation over perfect technical implementation! 🛡️