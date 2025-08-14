import express from 'express'
import { authenticateToken } from '../middlewares/auth.js'
import { update_profile_controller } from '../controllers/auth_controller.js'

const router = express.Router()

router.get('/profile', authenticateToken, (req, res) => {
  res.json({
    message: 'Perfil privado',
    user: req.user 
  })
})

router.put('/profile', authenticateToken, update_profile_controller)

export default router
