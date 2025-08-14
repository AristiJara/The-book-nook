import express from 'express'
import { authenticateToken, isAdmin } from '../middlewares/auth.js'
import { create_book_controller, delete_book_controller } from '../controllers/book_controller.js'
import { BookRepository } from '../models/book_repository.js'

const router = express.Router()

router.post('/create', authenticateToken, isAdmin, create_book_controller)
router.delete('/:id', authenticateToken, isAdmin, delete_book_controller)
router.get('/', async (req, res) => {
  try {
    const books = await BookRepository.findAll()
    res.status(200).json(books)
  } catch (error) {
    res.status(500).json({ message: error.message })
  }
})

export default router