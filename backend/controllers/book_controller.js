import { BookRepository} from '../models/book_repository.js'

export const create_book_controller = async (req, res) => {
  const { title, author, price, description } = req.body  
  
  try {
    const newBook = await BookRepository.create({ title, author, price, description })
    res.status(201).json({ message: 'Book created successfully', book: newBook })
  } catch (error) {
    res.status(400).json({ message: error.message })
  }
}

export const delete_book_controller = async (req, res) => {
  const { id } = req.params

  try {
    await BookRepository.delete(id)
    res.status(200).json({ message: 'Book deleted successfully' })
  } catch (error) {
    res.status(400).json({ message: error.message })
  }
}