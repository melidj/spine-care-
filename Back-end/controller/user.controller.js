const UserService = require("../services/user.services");

exports.register = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const successRes = await UserService.registerUser(email, password);
        // Optionally, handle successRes if needed

        res.json({ status: true, success: "User Registered Successfully" });
    } catch (error) {
        res.status(500).json({ status: false, message: error.message || "Registration failed" });
    }
};

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await UserService.checkuser(email);

        if (!user) {
            return res.status(400).json({ status: false, message: 'User does not exist' });
        }

        // Ensure comparePassword returns a promise
        const isMatch = await user.comparePassword(password);
        if (!isMatch) {
            return res.status(400).json({ status: false, message: 'Invalid password' });
        }

        let tokenData = { _id: user._id, email: user.email };

        // Assuming generateToken returns a promise
        const token = await UserService.generateToken(tokenData, "secretKey", '1h');

        res.status(200).json({ status: true, token: token });
    } catch (error) {
        // Properly handle the error
        res.status(500).json({ status: false, message: error.message || "Login failed" });
    }
};
