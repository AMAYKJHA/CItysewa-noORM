import { useState } from "react";
import "../Style/JoinOurTeam.css";

const JoinOurTeam = () => {
    const [formData, setFormData] = useState({
        name: "",
        email: "",
        role: "",
        skills: "",
        portfolio: "",
        message: "",
    });
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");
    const [fieldErrors, setFieldErrors] = useState({});
    const [submitting, setSubmitting] = useState(false);

    const validate = () => {
        const newErrors = {};

        if (!formData.name.trim()) {
            newErrors.name = "Name is required.";
        }
        if (!formData.email.trim()) {
            newErrors.email = "Email is required.";
        } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email.trim())) {
            newErrors.email = "Please enter a valid email address.";
        }
        if (!formData.role.trim()) {
            newErrors.role = "Please tell us which role you are interested in.";
        }
        if (!formData.skills.trim()) {
            newErrors.skills = "Please share your primary skills or tech stack.";
        }
        if (!formData.message.trim()) {
            newErrors.message = "Please add a short note about why you want to join.";
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

        if (fieldErrors[name]) {
            setFieldErrors((prev) => {
                const updated = { ...prev };
                delete updated[name];
                return updated;
            });
        }
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        setError("");
        setSuccess("");

        if (!validate()) {
            return;
        }

        setSubmitting(true);
        try {
            const mailto = new URL("mailto:contact@citysewa.com");
            const subject = `Join CitySewa Dev Team - ${formData.role}`;
            const bodyLines = [
                `Name: ${formData.name}`,
                `Email: ${formData.email}`,
                `Role interested in: ${formData.role}`,
                `Skills / Tech stack: ${formData.skills}`,
                formData.portfolio ? `Portfolio / GitHub: ${formData.portfolio}` : "",
                "",
                "Message:",
                formData.message,
            ].filter(Boolean);

            mailto.searchParams.set("subject", subject);
            mailto.searchParams.set("body", bodyLines.join("%0D%0A"));

            window.location.href = mailto.toString();
            setSuccess("Thank you! Your email client should open with the application details.");
        } catch (err) {
            setError("Something went wrong while preparing your application. Please email contact@citysewa.com directly.");
        } finally {
            setSubmitting(false);
        }
    };

    return (
        <div className="join-our-team-page">
            <div className="join-hero">
                <h1>Join Our Team</h1>
                <p className="join-subtitle">Help us build the next-generation hyperlocal services platform</p>
            </div>

            <div className="join-content">
                <div className="join-info">
                    <h2>Why Join the CitySewa Dev Team?</h2>
                    <ul className="benefits-list">
                        <li>
                            <strong>Real-world impact</strong>
                            <p>Work on a product that directly helps local communities and service providers.</p>
                        </li>
                        <li>
                            <strong>Modern stack</strong>
                            <p>Contribute to a real React / Django based system with clean architecture.</p>
                        </li>
                        <li>
                            <strong>Learning & collaboration</strong>
                            <p>Pair with other contributors, review code, and learn best practices.</p>
                        </li>
                        <li>
                            <strong>Portfolio ready</strong>
                            <p>Ship meaningful features you can talk about in interviews.</p>
                        </li>
                    </ul>
                </div>

                <form className="join-form" onSubmit={handleSubmit} noValidate>
                    <fieldset>
                        <legend>Development Team Application</legend>
                        {error && <p className="error" role="alert">{error}</p>}
                        {success && <p className="success" role="alert">{success}</p>}

                        <span>
                            <label htmlFor="join-name">Full Name</label>
                            <input
                                type="text"
                                id="join-name"
                                name="name"
                                value={formData.name}
                                onChange={handleChange}
                                autoComplete="name"
                                placeholder="Your name"
                            />
                            {fieldErrors.name && (
                                <small className="field-error">{fieldErrors.name}</small>
                            )}
                        </span>

                        <span>
                            <label htmlFor="join-email">Email</label>
                            <input
                                type="email"
                                id="join-email"
                                name="email"
                                value={formData.email}
                                onChange={handleChange}
                                autoComplete="email"
                                placeholder="giyu@example.com"
                            />
                            {fieldErrors.email && (
                                <small className="field-error">{fieldErrors.email}</small>
                            )}
                        </span>

                        <span>
                            <label htmlFor="join-role">Role / Interest</label>
                            <input
                                type="text"
                                id="join-role"
                                name="role"
                                value={formData.role}
                                onChange={handleChange}
                                placeholder="e.g. Frontend, Backend, Fullstack, UX"
                            />
                            {fieldErrors.role && (
                                <small className="field-error">{fieldErrors.role}</small>
                            )}
                        </span>

                        <span>
                            <label htmlFor="join-skills">Skills / Tech Stack</label>
                            <input
                                type="text"
                                id="join-skills"
                                name="skills"
                                value={formData.skills}
                                onChange={handleChange}
                                placeholder="e.g. React, TypeScript, Django, Postgres"
                            />
                            {fieldErrors.skills && (
                                <small className="field-error">{fieldErrors.skills}</small>
                            )}
                        </span>

                        <span>
                            <label htmlFor="join-portfolio">Portfolio / GitHub (optional)</label>
                            <input
                                type="url"
                                id="join-portfolio"
                                name="portfolio"
                                value={formData.portfolio}
                                onChange={handleChange}
                                placeholder="https://github.com/username"
                            />
                        </span>

                        <span>
                            <label htmlFor="join-message">Why do you want to join?</label>
                            <textarea
                                id="join-message"
                                name="message"
                                value={formData.message}
                                onChange={handleChange}
                                rows={4}
                                placeholder="Share a short note about your experience and what you would like to work on."
                            />
                            {fieldErrors.message && (
                                <small className="field-error">{fieldErrors.message}</small>
                            )}
                        </span>

                        <button type="submit" disabled={submitting}>
                            {submitting ? "Preparing email…" : "Submit Application"}
                        </button>
                    </fieldset>
                </form>
            </div>
        </div>
    );
};

export default JoinOurTeam;
