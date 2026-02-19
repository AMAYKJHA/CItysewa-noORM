import { useState } from "react";
import "../../Style/Root.css"
import "../../Style/Login.css";

const ForgotPassword = () => {
    const [email, setEmail] = useState("");
    const [submitted, setSubmitted] = useState(false);
    const [error, setError] = useState("");

    const handleSubmit = (e) => {
        e.preventDefault();
        setError("");

        if (!email.trim()) {
            setError("Email is required.");
            return;
        }

        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())) {
            setError("Please enter a valid email address.");
            return;
        }

        setSubmitted(true);
        // In a real app, we would call a password reset endpoint here.
    };

    return (
        <div className="login-page">
            <div className="login-card">
                <form className="login-form-inner" onSubmit={handleSubmit} noValidate>
                    <div className="login-header">
                        <h1 className="login-title">Reset your password</h1>
                        <p className="login-subtitle">
                            Enter the email associated with your account and we&apos;ll send you a reset link.
                        </p>
                    </div>
                    <div className="login-fields">
                        {submitted && !error && (
                            <div className="login-error" role="status" style={{ backgroundColor: "rgba(46, 204, 113, 0.12)", color: "#27ae60", borderColor: "rgba(46, 204, 113, 0.4)" }}>
                                If an account exists for <strong>{email}</strong>, you&apos;ll receive an email with instructions to reset your password.
                            </div>
                        )}
                        {error && !submitted && (
                            <div className="login-error" role="alert">
                                {error}
                            </div>
                        )}
                        <div className="login-field">
                            <label htmlFor="forgot-email">Email</label>
                            <input
                                id="forgot-email"
                                type="email"
                                name="email"
                                value={email}
                                onChange={(e) => {
                                    setEmail(e.target.value);
                                    if (error) setError("");
                                }}
                                autoComplete="email"
                                placeholder="you@example.com"
                            />
                        </div>
                        <button type="submit" className="login-submit-btn">
                            Send reset link
                        </button>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default ForgotPassword;