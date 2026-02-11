import { Link } from "react-router-dom";
import "../Style/About.css";

const About = () => {
    return(
        <section className="about">
            <header className="about-hero">
                <div className="about-hero-text">
                    <p className="eyebrow">About CitySewa</p>
                    <h1>Local skills, trusted service, real impact.</h1>
                    <p>
                        CitySewa connects neighborhood talent with people who need help today.
                        From electricians to tutors, we make discovery, booking, and trust simple.
                    </p>
                    <div className="about-hero-actions">
                        <Link to="/services" className="btn primary">Explore Services</Link>
                        <Link to="/register-admin" className="btn ghost">Join Our Team</Link>
                    </div>
                </div>
                <div className="about-hero-card">
                    <div>
                        <h3>Quality-first marketplace</h3>
                        <p>
                            Verified profiles, clear pricing, and consistent communication help
                            every booking feel reliable.
                        </p>
                    </div>
                    <div className="hero-stats">
                        <span>
                            <strong>30+</strong>
                            <small>service categories</small>
                        </span>
                        <span>
                            <strong>4.8/5</strong>
                            <small>average rating</small>
                        </span>
                        <span>
                            <strong>24h</strong>
                            <small>avg. response time</small>
                        </span>
                    </div>
                </div>
            </header>

            <section className="about-grid">
                <article>
                    <h3>For customers</h3>
                    <p>
                        Browse verified professionals, compare services, and schedule without
                        the back-and-forth. Every booking is secured with clear expectations.
                    </p>
                </article>
                <article>
                    <h3>For providers</h3>
                    <p>
                        Build your reputation, manage bookings, and grow your local network
                        with tools designed for independent professionals.
                    </p>
                </article>
                <article>
                    <h3>For communities</h3>
                    <p>
                        CitySewa keeps spending local, supports livelihoods, and makes trusted
                        services accessible when they matter most.
                    </p>
                </article>
            </section>

            <section className="about-values">
                <div className="value">
                    <h4>Trust & safety</h4>
                    <p>Verified profiles, transparent reviews, and secure communication.</p>
                </div>
                <div className="value">
                    <h4>Speed & clarity</h4>
                    <p>Fast discovery, honest pricing, and clear service expectations.</p>
                </div>
                <div className="value">
                    <h4>Local pride</h4>
                    <p>Empowering neighbors and strengthening community economies.</p>
                </div>
            </section>
        </section>
    );
};

export default About;