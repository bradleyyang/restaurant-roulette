const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    firstName: {
        type: String,
        required: true,
        minlength: 1,
        validate: {
            validator: (value) => value.trim().length > 0,
            message: 'First name cannot be empty.',
        },
    },
    lastName: {
        type: String,
        required: true,
        minlength: 1,
        validate: {
            validator: (value) => value.trim().length > 0,
            message: 'Last name cannot be empty.',
        },
    },
    password: {
        type: String,
        required: true,
        minlength: 6,
    },
    username: {
        type: String,
        required: true,
        minlength: 1,
        unique: true,
        validate: {
            validator: (value) => value.trim().length > 0,
            message: 'Username cannot be empty.',
        },
    },
    email: {
        type: String,
        required: true,
        unique: true,
        match: /.+\@.+\..+/,  // Basic email format validation
    },
    gender: {
        type: String,
        required: true,
        enum: ["Male", "Female", "Other"],
    },
    phoneNumber: {
        type: String,
        required: true,
        match: /^\+?\d{10,15}$/,  // Validates international phone format
    },
});

const User = mongoose.model('User', userSchema);

module.exports = User;