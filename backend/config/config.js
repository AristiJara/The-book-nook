import 'dotenv/config'

export const PORT = process.env.PORT
export const SECRET_JWT_KEY = process.env.SECRET_JWT_KEY
export const SALT_ROUNDS = parseInt(process.env.SALT_ROUNDS)