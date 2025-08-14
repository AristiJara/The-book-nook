import jwt from 'jsonwebtoken'
import { SECRET_JWT_KEY } from '../config/config.js'

export function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization']
  const token = authHeader && authHeader.split(' ')[1]

  if (!token) {
    return res.status(401).json({ message: 'Access token required' })
  }

  try {
    const decoded = jwt.verify(token, SECRET_JWT_KEY)
    req.user = decoded
    next()
  } catch (err) {
    return res.status(403).json({ message: 'Invalid or expired token' })
  }
}

export function isAdmin(req, res, next) {
  if (req.user?.role === 'admin') {
    next()
  } else {
    res.status(403).json({ message: 'Access denied: Admins only' })
  }
}