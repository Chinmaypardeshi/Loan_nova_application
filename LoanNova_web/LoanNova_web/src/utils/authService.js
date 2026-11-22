// ============================================================
//  LoanNova Auth Service
//  Shared backend: https://loan-nova-backend.onrender.com/api
//  Mirrors the Flutter ApiService (api_service.dart) so that
//  web and mobile users share the same account database.
// ============================================================

const BASE_URL = 'https://loan-nova-backend.onrender.com/api';

// ─── LOGIN ──────────────────────────────────────────────────
export async function login(email, password) {
  const res = await fetch(`${BASE_URL}/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ email, password }),
  });

  const data = await res.json();

  if (!res.ok) {
    throw new Error(data.message || 'Login failed');
  }

  // Persist token + userId exactly like the Flutter app does
  localStorage.setItem('loannova_token', data.token);
  if (data.userId != null) {
    localStorage.setItem('loannova_userId', String(data.userId));
  }
  if (data.name) {
    localStorage.setItem('loannova_name', data.name);
  }
  if (data.email) {
    localStorage.setItem('loannova_email', data.email);
  }

  return data;
}

// ─── REGISTER ───────────────────────────────────────────────
export async function register(name, email, phone, password) {
  const res = await fetch(`${BASE_URL}/auth/register`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ name, email, phone, password }),
  });

  const data = await res.json();

  if (!res.ok) {
    throw new Error(data.message || 'Registration failed');
  }

  return data;
}

// ─── TOKEN / SESSION HELPERS ────────────────────────────────
export function getToken() {
  return localStorage.getItem('loannova_token');
}

export function getUserId() {
  return localStorage.getItem('loannova_userId');
}

export function getSavedName() {
  return localStorage.getItem('loannova_name');
}

export function getSavedEmail() {
  return localStorage.getItem('loannova_email');
}

export function isLoggedIn() {
  return !!getToken();
}

// ─── LOGOUT ─────────────────────────────────────────────────
export function logout() {
  localStorage.removeItem('loannova_token');
  localStorage.removeItem('loannova_userId');
  localStorage.removeItem('loannova_name');
  localStorage.removeItem('loannova_email');
}

// ─── AUTH HEADERS (for protected API calls) ─────────────────
export function getAuthHeaders() {
  return {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${getToken()}`,
  };
}
