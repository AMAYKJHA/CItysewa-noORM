import { useState, useEffect } from 'react';
import '../../Style/Home.css';

const Stats = () => {
    const [stats, setStats] = useState({
        users: 0,
        providers: 0,
        services: 0,
        bookings: 0
    });

    useEffect(() => {
        // Animate stats on mount
        const animateStats = () => {
            setStats({
                users: 10500,
                providers: 2300,
                services: 450,
                bookings: 47000
            });
        };

        const timer = setTimeout(animateStats, 300);
        return () => clearTimeout(timer);
    }, []);

    const statItems = [
        { label: 'Active Users', value: stats.users, formatted: '10.5K+' },
        { label: 'Service Providers', value: stats.providers, formatted: '2.3K+' },
        { label: 'Services Offered', value: stats.services, formatted: '450+' },
        { label: 'Completed Bookings', value: stats.bookings, formatted: '47K+' },
    ];

    return (
        <section className="stats-section">
            <h2>Our Impact</h2>
            <p className="subtitle">Growing community of trust and service</p>
            
            <div className="stats-grid">
                {statItems.map((stat, idx) => (
                    <div key={idx} className="stat-card">
                        <div className="stat-number">{stat.formatted}</div>
                        <p className="stat-label">{stat.label}</p>
                    </div>
                ))}
            </div>
        </section>
    );
};

export default Stats;
