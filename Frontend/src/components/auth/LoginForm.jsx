import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "../../hooks/useAuth";
import csLogo from "../../assets/cs.png";
import "../../Style/Root.css";
import "../../Style/Login.css";

/**
 * Shared login form with role selection.
 * @param {Object} props
 * @param {Array<{id: string, label: string}>} props.roles - Roles to choose from (e.g. [{id: "customer", label: "Customer"}, ...])
 * @param {string} props.defaultRole - Initial selected role
 * @param {function(string): Promise} props.getLoginApi - Returns the API function for the given role
 * @param {function(string): string} props.getRedirectPath - Returns redirect path after successful login
 * @param {string} props.registerPath - Path to registration (e.g. /register or /register-admin)
 * @param {string} [props.registerLabel="Sign Up"] - Label for the register link
 * @param {boolean} [props.showForgotPassword=true] - Whether to show forgot password link
 */
const LoginForm = ({
    roles,
    defaultRole,
    getLoginApi,
    getRedirectPath,
    registerPath,
    registerLabel = "Sign Up",
    showForgotPassword = true,
}) => {
    const { login } = useAuth();
    const navigate = useNavigate();
    const roleList = Array.isArray(roles) ? roles : [];
    const [role, setRole] = useState(defaultRole || roleList[0]?.id);
    const [credentials, setCredentials] = useState({ email: "", password: "" });
    const [error, setError] = useState("");
    const [fieldErrors, setFieldErrors] = useState({});
    const [submitting, setSubmitting] = useState(false);

    const hasRoleSelector = roleList.length > 1;
    const currentRoleLabel = roleList.find((r) => r.id === role)?.label || role;

    const validate = () => {
        const newErrors = {};
        if (!credentials.email.trim()) newErrors.email = "Email is required.";
        if (!credentials.password.trim()) newErrors.password = "Password is required.";
        else if (credentials.password.length < 6) newErrors.password = "Password must be at least 6 characters.";
        setFieldErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleChange = (e) => {
        const { name, value } = e.target;
        setCredentials((prev) => ({ ...prev, [name]: value }));
        if (fieldErrors[name]) setFieldErrors((prev) => ({ ...prev, [name]: undefined }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError("");
        if (!validate()) return;
        setSubmitting(true);
        try {
            const loginApi = getLoginApi(role);
            const response = await loginApi(credentials);
            login({ ...response.data, role });
            navigate(getRedirectPath(role));
        } catch (err) {
            setError(err.response?.data?.message || "Invalid email or password");
            setCredentials({ email: "", password: "" });
        } finally {
            setSubmitting(false);
        }
    };

    return (
        <div className="login-page">
            <div className={`login-card ${hasRoleSelector ? "login-card--with-role-selector" : ""}`}>
                {hasRoleSelector && (
                    <div className="login-role-selector" role="tablist" aria-label="Select login type">
                        {roleList.map((r) => (
                            <button
                                key={r.id}
                                type="button"
                                role="tab"
                                aria-selected={role === r.id}
                                className={`login-role-tab ${role === r.id ? "active" : ""}`}
                                onClick={() => setRole(r.id)}
                            >
                                {r.label}
                            </button>
                        ))}
                    </div>
                )}
                {!hasRoleSelector && (
                    <div className="login-role-badge" aria-hidden="true">
                        {currentRoleLabel}
                    </div>
                )}
                <form className="login-form-inner" onSubmit={handleSubmit} noValidate>
                    <div className="login-header">
                        <div className="login-logo-wrapper">
                            <img src={csLogo} alt="CitySewa logo" className="login-logo" />
                        </div>
                        <h1 className="login-title">Welcome back</h1>
                        <p className="login-subtitle">Sign in to your {currentRoleLabel.toLowerCase()} account</p>
                    </div>
                    <div className="login-fields">
                        {error && <div className="login-error" role="alert">{error}</div>}
                        <div className="login-field">
                            <label htmlFor="login-email">Email</label>
                            <input
                                id="login-email"
                                type="text"
                                name="email"
                                value={credentials.email}
                                onChange={handleChange}
                                autoComplete="username"
                                placeholder="luffy@example.com"
                            />
                            {fieldErrors.email && <span className="login-field-error">{fieldErrors.email}</span>}
                        </div>
                        <div className="login-field">
                            <label htmlFor="login-password">Password</label>
                            <input
                                id="login-password"
                                type="password"
                                name="password"
                                value={credentials.password}
                                onChange={handleChange}
                                autoComplete="current-password"
                                placeholder="••••••••"
                            />
                            {fieldErrors.password && <span className="login-field-error">{fieldErrors.password}</span>}
                        </div>
                        {showForgotPassword && (
                            <div className="login-actions-row">
                                <Link to="/forgot-password" className="login-link login-link--forgot">
                                    Forgot password?
                                </Link>
                            </div>
                        )}
                        <button type="submit" className="login-submit-btn" disabled={submitting}>
                            {submitting ? "Signing in…" : "Sign in"}
                        </button>
                        <p className="login-footer">
                            Don&apos;t have an account?{" "}
                            <Link to={registerPath} className="login-link login-link--register">
                                {registerLabel}
                            </Link>
                        </p>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default LoginForm;
