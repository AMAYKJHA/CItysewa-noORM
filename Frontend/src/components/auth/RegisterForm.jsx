import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import csLogo from "../../assets/cs.png";
import "../../Style/Root.css";
import "../../Style/Register.css";

/**
 * Shared register form with role selection and password strength.
 * @param {Object} props
 * @param {Array<{id: string, label: string}>} props.roles - Roles to choose from (e.g. [{id: "customer", label: "Customer"}, ...])
 * @param {string} props.defaultRole - Initial selected role
 * @param {function(string): Promise} props.getRegisterApi - Returns the API function for the given role
 * @param {function(string): string} props.getRedirectPath - Returns redirect path after successful registration
 * @param {string} props.loginPath - Path to login (e.g. /login or /login-admin)
 * @param {string} [props.loginLabel="Sign In"] - Label for the login link
 * @param {boolean} [props.showRoleSelector=true] - Whether to show role selector (false for admin)
 * @param {boolean} [props.showNameFields=true] - Whether to show first_name and last_name fields
 * @param {boolean} [props.showGenderField=true] - Whether to show gender field
 */
const RegisterForm = ({
    roles,
    defaultRole,
    getRegisterApi,
    getRedirectPath,
    loginPath,
    loginLabel = "Sign In",
    showRoleSelector = true,
    showNameFields = true,
    showGenderField = true,
}) => {
    const navigate = useNavigate();
    const roleList = Array.isArray(roles) ? roles : [];
    const [role, setRole] = useState(defaultRole || roleList[0]?.id);
    const [formData, setFormData] = useState({
        email: "",
        first_name: "",
        last_name: "",
        gender: "",
        password: "",
        confirmPassword: "",
        role: defaultRole || roleList[0]?.id || "",
    });
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    const [fieldErrors, setFieldErrors] = useState({});
    const [submitting, setSubmitting] = useState(false);

    const hasRoleSelector = showRoleSelector && roleList.length > 1;
    const currentRoleLabel = roleList.find((r) => r.id === role)?.label || role || "User";

    const getPasswordStrength = (password) => {
        if (!password) {
            return { label: "", level: "empty" };
        }

        let score = 0;
        if (password.length >= 8) score++;
        if (password.length >= 12) score++;
        if (/[A-Z]/.test(password)) score++;
        if (/[0-9]/.test(password)) score++;
        if (/[^A-Za-z0-9]/.test(password)) score++;

        if (score <= 2) return { label: "Weak password", level: "weak" };
        if (score === 3 || score === 4) return { label: "Medium strength", level: "medium" };
        return { label: "Strong password", level: "strong" };
    };

    const validate = () => {
        const newErrors = {};

        if (!formData.email.trim()) {
            newErrors.email = "Email is required.";
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email.trim())) {
            newErrors.email = "Please enter a valid email address.";
        }

        if (showNameFields) {
            if (!formData.first_name.trim()) {
                newErrors.first_name = "First name is required.";
            }
            if (!formData.last_name.trim()) {
                newErrors.last_name = "Last name is required.";
            }
        }

        if (showGenderField && !formData.gender) {
            newErrors.gender = "Please select your gender.";
        }

        if (!formData.password.trim()) {
            newErrors.password = "Password is required.";
        } else if (formData.password.length < 8) {
            newErrors.password = "Password must be at least 8 characters.";
        }

        if (!formData.confirmPassword.trim()) {
            newErrors.confirmPassword = "Please confirm your password.";
        } else if (formData.password !== formData.confirmPassword) {
            newErrors.confirmPassword = "Passwords do not match.";
        }

        if (!formData.role) {
            newErrors.role = "Please select a role.";
        }

        setFieldErrors(newErrors);
        return Object.keys(newErrors).length === 0;
    };

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData((prev) => ({
            ...prev,
            [name]: value,
        }));

        // Sync role state when role changes
        if (name === "role" && showRoleSelector) {
            setRole(value.toLowerCase());
        }

        if (fieldErrors[name]) {
            setFieldErrors((prev) => {
                const updated = { ...prev };
                delete updated[name];
                return updated;
            });
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError("");
        setSuccess("");

        if (!validate()) {
            return;
        }

        setSubmitting(true);
        try {
            const registerApi = getRegisterApi(formData.role);
            const roleLower = formData.role.toLowerCase();
            
            let payload = {
                email: formData.email,
                password: formData.password,
            };

            if (showNameFields) {
                payload.first_name = formData.first_name;
                payload.last_name = formData.last_name;
            }

            if (showGenderField) {
                payload.gender = formData.gender;
            }

            await registerApi(payload);
            setSuccess(`${currentRoleLabel} Registration Successful!`);
            setTimeout(() => {
                navigate(getRedirectPath(roleLower));
            }, 1500);
        } catch (err) {
            setError(err.response?.data?.message || "Registration Failed!");
            setFormData({
                email: "",
                first_name: "",
                last_name: "",
                gender: "",
                password: "",
                confirmPassword: "",
                role: defaultRole || roleList[0]?.id || "",
            });
            setFieldErrors({});
        } finally {
            setSubmitting(false);
        }
    };

    const passwordStrength = getPasswordStrength(formData.password);

    return (
        <form
            className={`register-form ${!showRoleSelector ? "register-admin-form" : ""}`}
            onSubmit={handleSubmit}
            noValidate
        >
            <fieldset>
                <div className="register-logo-wrapper">
                    <img src={csLogo} alt="CitySewa logo" className="register-logo" />
                </div>
                <legend>{showRoleSelector ? "Register" : "Admin Register"}</legend>
                {error && <p className="error" role="alert">{error}</p>}
                {success && <p className="success" role="alert">{success}</p>}
                
                {hasRoleSelector && (
                    <span>
                        <label htmlFor="select-role">Your Role</label>
                        <select
                            className="select-role"
                            id="select-role"
                            name="role"
                            value={formData.role}
                            onChange={handleChange}
                        >
                            <option value={""} disabled hidden>
                                Choose an option
                            </option>
                            {roleList.map((r) => (
                                <option key={r.id} value={r.id}>
                                    {r.label}
                                </option>
                            ))}
                        </select>
                        {fieldErrors.role && (
                            <small className="field-error">{fieldErrors.role}</small>
                        )}
                    </span>
                )}

                {!hasRoleSelector && (
                    <span>
                        <label htmlFor="select-role">Your Role</label>
                        <select
                            className="select-role"
                            id="select-role"
                            name="role"
                            value={formData.role}
                            onChange={handleChange}
                            disabled
                        >
                            <option value={formData.role}>{currentRoleLabel}</option>
                        </select>
                        {fieldErrors.role && (
                            <small className="field-error">{fieldErrors.role}</small>
                        )}
                    </span>
                )}

                <span>
                    <label htmlFor="reg-email">Enter your email</label>
                    <input
                        type="email"
                        id="reg-email"
                        name="email"
                        value={formData.email}
                        onChange={handleChange}
                        autoComplete="email"
                        placeholder="charizard@example.com"
                    />
                    {fieldErrors.email && (
                        <small className="field-error">{fieldErrors.email}</small>
                    )}
                </span>

                {showNameFields && (
                    <span>
                        <span>
                            <label htmlFor="reg-fname">First Name</label>
                            <input
                                type="text"
                                id="reg-fname"
                                name="first_name"
                                value={formData.first_name}
                                onChange={handleChange}
                                autoComplete="given-name"
                                placeholder="John"
                            />
                            {fieldErrors.first_name && (
                                <small className="field-error">{fieldErrors.first_name}</small>
                            )}
                        </span>
                        <span>
                            <label htmlFor="reg-lname">Last Name</label>
                            <input
                                type="text"
                                id="reg-lname"
                                name="last_name"
                                value={formData.last_name}
                                onChange={handleChange}
                                autoComplete="family-name"
                                placeholder="Doe"
                            />
                            {fieldErrors.last_name && (
                                <small className="field-error">{fieldErrors.last_name}</small>
                            )}
                        </span>
                    </span>
                )}

                {showGenderField && (
                    <span>
                        <label>Gender</label>
                        <select
                            className="select-gender"
                            name="gender"
                            value={formData.gender}
                            onChange={handleChange}
                        >
                            <option value={""} disabled hidden>
                                Choose your gender
                            </option>
                            <option value={"Female"}>Female</option>
                            <option value={"Male"}>Male</option>
                            <option value={"Others"}>Others</option>
                        </select>
                        {fieldErrors.gender && (
                            <small className="field-error">{fieldErrors.gender}</small>
                        )}
                    </span>
                )}

                <span>
                    <label htmlFor="reg-pass">Password</label>
                    <input
                        type="password"
                        id="reg-pass"
                        name="password"
                        value={formData.password}
                        onChange={handleChange}
                        autoComplete="new-password"
                        placeholder="••••••••"
                    />
                    {fieldErrors.password && (
                        <small className="field-error">{fieldErrors.password}</small>
                    )}
                    {formData.password && (
                        <div className={`password-strength strength-${passwordStrength.level}`}>
                            <div className="password-strength-bar">
                                <span className="segment" />
                                <span className={`segment ${passwordStrength.level !== "weak" ? "filled" : ""}`} />
                                <span className={`segment ${passwordStrength.level === "strong" ? "filled" : ""}`} />
                            </div>
                            <small className="password-strength-label">{passwordStrength.label}</small>
                        </div>
                    )}
                </span>

                <span>
                    <label htmlFor="reg-confirm-pass">Confirm Password</label>
                    <input
                        type="password"
                        id="reg-confirm-pass"
                        name="confirmPassword"
                        value={formData.confirmPassword}
                        onChange={handleChange}
                        autoComplete="new-password"
                        placeholder="••••••••"
                    />
                    {fieldErrors.confirmPassword && (
                        <small className="field-error">{fieldErrors.confirmPassword}</small>
                    )}
                </span>

                <button type="submit" disabled={submitting}>
                    {submitting ? "Registering…" : "Register"}
                </button>

                <p className="register-footer">
                    Already have an account?{" "}
                    <Link to={loginPath} className="register-link">
                        {loginLabel}
                    </Link>
                </p>
            </fieldset>
        </form>
    );
};

export default RegisterForm;
