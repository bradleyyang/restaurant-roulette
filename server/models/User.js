const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    firstName: {
        type: String,
        required: true,
        minlength: 1
    },
    lastName: {
        type: String,
        required: true,
        minlength: 1
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
        unique: true
    },
    email: {
        type: String,
        required: true,

    },
    gender: {
        type: String,
        required: true,
        enum: ["Male", "Female", "Other"],
    },
    phoneNumber: {
        type: String,
        required: true
    }

});

userSchema.path('username').validate(function (value) {
    return value.trim().length > 0;
}, 'Username cannot be empty.');


userSchema.path('firstName').validate(function (value) {
    return value.trim().length > 0; 
}, 'First name cannot be empty.');

userSchema.path('lastName').validate(function (value) {
    return value.trim().length > 0; 
}, 'Last name cannot be empty.');

const User = mongoose.model('User', userSchema);

module.exports = User;