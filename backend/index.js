import 'dotenv/config'
import express from 'express'
import authRoutes from './routes/auth_routes.js'
import profileRoutes from './routes/profile_routes.js'
import booksRoutes from './routes/book_routes.js'

const app = express()
app.use(express.json())

app.use('/auth', authRoutes)
app.use('/user', profileRoutes)
app.use('/book', booksRoutes)

try {
  const PORT = process.env.PORT || 3000
  app.listen(PORT, () => console.log(`Server running on port ${PORT}`))
}catch (e) {
  console.log(e)
}