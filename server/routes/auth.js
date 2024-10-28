const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const cookieParser = require('cookie-parser');

const router = express.Router();

router.use(cookieParser());


const authMiddleware = require('../middleware/authMiddleware');

router.get('/protected', authMiddleware, (req, res) => {
    const { id, username, firstName, lastName, email, gender, phoneNumber } = req.user;

    res.status(200).json({
        message: 'This is a protected route',
        user: {
            id,
            firstName,
            lastName,
            username,
            email,
            gender,
            phoneNumber
        }
    });
});

// User Registration
router.post('/register', async (req, res) => {
    const { firstName, lastName, username, email, password, gender, phoneNumber } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({ username, email, password: hashedPassword, firstName, lastName, gender, phoneNumber });
    try {
        await newUser.save();
        res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// User Login
router.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        const user = await User.findOne({ username });
        if (!user) return res.status(404).json({ message: 'User not found' });

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(401).json({ message: 'Invalid credentials' });

        const token = jwt.sign({
            id: user._id,
            username: user.username,
            email: user.email,
            gender: user.gender,
            firstName: user.firstName,
            lastName: user.lastName,
            phoneNumber: user.phoneNumber
        }, process.env.JWT_SECRET, { expiresIn: '1h' });


        
        res.cookie('authToken', token, {
            httpOnly: true, // Prevents JavaScript access
            secure: true,   // Ensures cookies are sent over HTTPS
            sameSite: 'Strict', // Controls when cookies are sent
            maxAge: 3600000 // Optional: Set cookie expiration
        });

        // Send the user information along with the success message
        res.status(200).json({
            message: 'Login successful',
            user: {
                username: user.username,
                email: user.email,
                gender: user.gender,
                firstName: user.firstName,
                lastName: user.lastName,
                phoneNumber: user.phoneNumber
            }
        });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


// User logout

router.post('/logout', (req, res) => {
    res.clearCookie('authToken'); // Clear the cookie
    res.json({ message: 'Logout successful' });
});

module.exports = router;