// Simple test script to verify cart sync
// Run this in browser console after adding items as guest and before login

console.log('=== CART SYNC TEST ===');

// Check initial state
const guestCart = localStorage.getItem('guestCart');
const user = localStorage.getItem('user');

console.log('1. Initial State:');
console.log('   Guest Cart:', guestCart ? JSON.parse(guestCart).length + ' items' : 'Empty');
console.log('   User:', user ? JSON.parse(user).name : 'Not logged in');

if (guestCart && !user) {
    const items = JSON.parse(guestCart);
    console.log('   Guest Cart Items:');
    items.forEach((item, i) => {
        console.log(`     ${i+1}. ${item.name} (qty: ${item.quantity})`);
    });
    
    console.log('\n2. Ready for login test');
    console.log('   Next: Login and check if items sync correctly');
    
    // Set up monitoring
    const originalSetItem = localStorage.setItem;
    const originalRemoveItem = localStorage.removeItem;
    
    localStorage.setItem = function(key, value) {
        if (key.startsWith('cartSynced_') || key === 'guestCart') {
            console.log('   localStorage.setItem:', key, value.substring(0, 50) + '...');
        }
        return originalSetItem.call(this, key, value);
    };
    
    localStorage.removeItem = function(key) {
        if (key.startsWith('cartSynced_') || key === 'guestCart') {
            console.log('   localStorage.removeItem:', key);
        }
        return originalRemoveItem.call(this, key);
    };
    
    console.log('   Monitoring localStorage changes...');
    
} else if (user && !guestCart) {
    const userData = JSON.parse(user);
    const syncKey = `cartSynced_${userData.id}`;
    const isSynced = localStorage.getItem(syncKey);
    
    console.log('\n2. After Login State:');
    console.log('   User:', userData.name, '(ID:', userData.id + ')');
    console.log('   Guest Cart:', 'Cleared');
    console.log('   Sync Status:', isSynced ? 'Synced' : 'Not Synced');
    
    if (isSynced) {
        console.log('   ✅ Sync appears successful');
        console.log('   Next: Check if items appear in user cart');
    } else {
        console.log('   ❌ Sync flag not set - sync may have failed');
    }
    
} else if (user && guestCart) {
    console.log('\n2. Problem Detected:');
    console.log('   ❌ User is logged in but guest cart still exists');
    console.log('   This indicates sync process failed');
    
} else {
    console.log('\n2. No test data:');
    console.log('   Add items to cart as guest first, then run this test');
}

console.log('\n=== END TEST ===');