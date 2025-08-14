import jwt from 'jsonwebtoken'
import { UserRepository } from '../models/user_repository.js'
import { SECRET_JWT_KEY } from '../config/config.js'

export const register_controller = async (req, res) => {
  const { email, password, role } = req.body
  try {
    const existingUser = await UserRepository.findByEmail(email);
    if (existingUser) {
      return res.status(400).json({ message: 'The email is already registered'})
    }
    await UserRepository.create({ email, password, role })
    res.status(201).json({ message: 'Account created successfully' })
  } catch (error) {
    res.status(400).json({ message: error.message })
  }
}

export const login_controller = async (req, res) => {
  const { email, password } = req.body
  try {
    const user = await UserRepository.login({ email, password })

    const accessToken = jwt.sign(
      { id: user.id, email: user.email, role: user.role }, 
      SECRET_JWT_KEY, 
      { expiresIn: '1m' }
    )

    const refreshToken = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      SECRET_JWT_KEY,
      { expiresIn: '7d' }
    )

    res.status(200).json({ user, token: accessToken, refreshToken, role: user.role });
  } catch (error) {
    res.status(401).json({ message: error.message })
  }
}

export const refreshToken_controller = (req, res) => {
  const { token } = req.body;
  if (!token) return res.status(401).json({ message: 'Refresh token required' });

  try {
    const decoded = jwt.verify(token, SECRET_JWT_KEY);

    const newAccessToken = jwt.sign(
      { id: decoded.id, email: decoded.email, role: decoded.role },
      SECRET_JWT_KEY,
      { expiresIn: '1m' }
    );

    res.status(200).json({ token: newAccessToken });
  } catch (err) {
    return res.status(403).json({ message: 'Invalid refresh token' });
  }
};

export const update_profile_controller = async (req, res) => {
  const { email } = req.user
  const { username, birthday, phone_number } = req.body

  try {
   const updatedUser = await UserRepository.updateProfile(email, {
    username,
    birthday,
    phone_number
   })

   res.status(200).json({ message: 'Profile updated successfully', user: updatedUser})
  } catch (error) {
    res.status(400).json({ message: error.message})
  }

}

export const logout_controller = (req, res) => {
  res.json({ message: 'Logout successful' })
}