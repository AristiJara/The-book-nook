import express from 'express'
import { 
    login_controller, 
    logout_controller, 
    register_controller,
    refreshToken_controller 
} from '../controllers/auth_controller.js'

const router = express.Router()

router.post('/register', register_controller)
router.post('/login', login_controller)
router.post('/logout', logout_controller)
router.post('/refresh-token', refreshToken_controller)

export default router