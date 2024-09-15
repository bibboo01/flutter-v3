const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');
const dotenv = require('dotenv');

dotenv.config();

exports.register = async (req, res) => {
    const { user_name, password, name, role } = req.body;

    // Input validation
    if (!user_name || !password) {
        return res.status(400).json({ message: 'User name and password are required.' });
    }

    try {
        // Check if user already exists
        const existingUser = await User.findOne({ user_name });
        if (existingUser) {
            return res.status(400).json({ message: 'User already exists.' });
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create and save the user
        const user = new User({ user_name, password: hashedPassword, name, role });
        const savedUser = await user.save();

        // Send response
        res.status(201).json({ message: 'User registered successfully', user: { user_name: savedUser.user_name } });
    } catch (err) {
        console.error('Registration error:', err.message);
        res.status(500).json({ message: 'Internal server error' });
    }
};

exports.login = async (req, res) => {
    const { user_name, password } = req.body;
    if (!user_name || !password) {
        return res.status(400).json({ message: 'User name and password are required.' });
    }

    try {
        const user_old = await User.findOne({ user_name });
        if (!user_old) { return res.status(400).json({ message: 'User not found' }); }
        const isMatch = await bcrypt.compare(password, user_old.password);
        if (!isMatch) { return res.status(400).json({ message: 'Invalid credentials' }); }

        const user = await User.findOne({ user_name }).select("-password");

        const accessToken = jwt.sign(
            { userId: user._id },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: '1h' }
        );
        const refreshToken = jwt.sign(
            { userId: user._id },
            process.env.REFRESH_TOKEN_SECRET,
            { expiresIn: '5m' }
        );
        res.status(200).json({ user: user, token: { accessToken, refreshToken }});
    } catch (err) {
        console.error('Login error:', err.message);
        res.status(500).json({ message: 'Internal server error' });
    }
};

exports.refresh = async (req, res) => {
    const { token } = req.body;

    if (!token) return res.status(401).json({ message: 'No token provided' });

    jwt.verify(token, process.env.REFRESH_TOKEN_SECRET, (err, user) => {
        if (err) return res.status(403).json({ message: 'Invalid token' });
        const accessToken = jwt.sign(
            { userId: user.userId },
            process.env.ACCESS_TOKEN_SECRET,
            { expiresIn: '15m' }
        );
        res.status(200).json({ accessToken });
    });
};
