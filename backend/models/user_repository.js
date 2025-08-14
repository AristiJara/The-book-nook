import DBLocal from 'db-local'
import crypto from 'node:crypto'
import bcrypt from 'bcrypt'
import { SALT_ROUNDS } from '../config/config.js'
const { Schema } = new DBLocal({ path: './database' })

const User = Schema('User', {
  _id: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  role: { type: String, required: true },
  username: {type: String, required: false},
  birthday: {type: String, required: false},
  phone_number: {type: String, required: false}
})  

export class UserRepository {
  static async create ({ email, password, role = false }) {
    Validation.email(email)
    Validation.password(password)
    Validation.role(role)

    const id = crypto.randomUUID()
    const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS)

    User.create({
      _id: id,
      email,
      password: hashedPassword,
      role
    }).save()

    return id
  }

  static async login ({ email, password }) {
    Validation.email(email)
    Validation.password(password)

    const user = User.findOne({ email })
    if (!user) throw new Error('email does not exist')

    const isValid = await bcrypt.compare(password, user.password)
    if (!isValid) throw new Error('password is invalid')

    const userData = { ...user }
    delete userData.password

    return userData
  }

  static async updateProfile(email, { username, birthday, phone_number }) {
    const user = User.findOne({ email })
    if (!user) throw new Error('User not found')

    if (username) user.username = username
    if (birthday) user.birthday = birthday
    if (phone_number) user.phone_number = phone_number

    user.save()

    const userData = { ...user }
    delete userData.password
    return userData
  }

  static async findByEmail(email) {
    return User.findOne({ email })
  }
}

class Validation {
  static email (email) {
    if (typeof email !== 'string') throw new Error('email must be a string')
    if (email.length < 3) throw new Error('email must be at least 3 characters long')
  }

  static password (password) {
    if (typeof password !== 'string') throw new Error('password must be a string')
    if (password.length < 6) throw new Error('password must be at least 6 characters long')
  }

  static role (role) {
    const validRoles = ['admin', 'user']
    if (typeof role !== 'string' || !validRoles.includes(role)) {
      throw new Error('Invalid role: must be "admin" or "user"')
    }
  }
}