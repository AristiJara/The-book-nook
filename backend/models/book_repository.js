import DBLocal from 'db-local'
import crypto from 'node:crypto'

const { Schema } = new DBLocal({ path: './database' })

const Book = Schema('Book', {
  _id: { type: String, required: true },
  title: { type: String, required: true },
  author: { type: String, required: true },
  price: { type: Number, required: true },
  description: { type: String, required: true }
})

export class BookRepository {

  static async create({ title, author, price, description }) {
    Validation.title(title)
    Validation.author(author)
    Validation.price(price)
    Validation.description(description)

    const id = crypto.randomUUID()

    const newBook = Book.create({
      _id: id,
      title,
      author,
      price,
      description
    }).save()

    return newBook
  }

  static async delete(id) {
    Validation.id(id)

    const book = Book.findOne({ _id: id })
    if (!book) throw new Error('Book not found')

    Book.remove({ _id: id })
    return book
  }

  static async findAll() {
    return Book.find()
  }

  static async findById(id) {
    Validation.id(id)

    const book = Book.findOne({ _id: id })
    if (!book) throw new Error('Book not found')

    return book
  }
} 

  class Validation {

  static id(id) {
    if (typeof id !== 'string' || id.trim().length === 0) {
      throw new Error('Invalid ID')
    }
  }

  static title(title) {
    if (typeof title !== 'string' || title.trim().length < 1) {
      throw new Error('Title is required')
    }
  }

  static author(author) {
    if (typeof author !== 'string' || author.trim().length < 1) {
      throw new Error('Author is required')
    }
  }

  static price(price) {
    if (typeof price !== 'number' || isNaN(price) || price < 0) {
        throw new Error('Price must be a valid positive number')
    }
  }

  static description(description) {
    if (typeof description !== 'string' || description.trim().length < 10) {
      throw new Error('Description is required and must be at least 10 characters long')
    }
  }
}