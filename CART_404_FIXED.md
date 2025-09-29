# ✅ Cart 404 Error Fixed

## Issue Fixed
**Problem:** Request failed with status code 404 saat menambahkan produk ke keranjang

**Root Cause:** Frontend cartService menggunakan endpoint yang berbeda dengan backend

## Solution Applied

### Frontend Fix - api.ts
**Before:**
```typescript
addToCart: async (productId: number, quantity: number) => {
  const response = await api.post(`/cart?productId=${productId}&quantity=${quantity}`);
  return response.data;
}
```

**After:**
```typescript
addToCart: async (productId: number, quantity: number) => {
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  const response = await api.post('/cart/add', {
    userId: user.id,
    productId: productId,
    quantity: quantity
  });
  return response.data;
}
```

### Backend Endpoints
- ✅ `POST /api/cart/add` - Add product to cart
- ✅ `GET /api/cart/{userId}` - Get user cart

## API Testing

### Add to Cart
```bash
curl -X POST -H "Content-Type: application/json" \
  -d '{"userId":1,"productId":1,"quantity":1}' \
  http://localhost:8191/api/cart/add

Response:
{
  "message": "Product added to cart successfully",
  "status": true,
  "data": null
}
```

### Get Cart
```bash
curl http://localhost:8191/api/cart/1

Response:
{
  "message": "Cart retrieved successfully",
  "status": true,
  "data": [...]
}
```

## Changes Made
1. **CartService**: Updated endpoint dari `/cart` ke `/cart/add`
2. **Request Format**: Changed dari query params ke JSON body
3. **User ID**: Added userId dari localStorage ke request

## Status: ✅ FIXED
Cart add functionality sekarang berfungsi dengan baik. Error 404 sudah resolved!