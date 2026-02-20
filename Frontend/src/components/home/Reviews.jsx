import '../../Style/Home.css';

const Reviews = () => {
    const testimonials = [
        {
            id: 1,
            name: 'Rakesh Kumar',
            role: 'Homeowner',
            text: 'Found a reliable electrician within minutes. Professional work and fair pricing!',
            rating: 5,
        },
        {
            id: 2,
            name: 'William Shakespear',
            role: 'Apartment Manager',
            text: 'CitySewa connected us with an excellent plumber. Quick response and quality service.',
            rating: 5,
        },
        {
            id: 3,
            name: 'Donald Trump',
            role: 'Service Provider',
            text: 'As a provider, this platform helped me grow my business significantly. Great support!',
            rating: 5,
        },
        {
            id: 4,
            name: 'Shah Rukh Khan',
            role: 'Customer',
            text: 'Love the transparency and ratings. Found the perfect cook for my events!',
            rating: 5,
        },
    ];

    return (
        <section className="reviews-section">
            <h2>What Our Users Say</h2>
            <p className="subtitle">Join thousands of satisfied customers</p>
            
            <div className="reviews-grid">
                {testimonials.map((review) => (
                    <div key={review.id} className="review-card">
                        <div className="stars">
                            {'⭐'.repeat(review.rating)}
                        </div>
                        <p className="review-text">"{review.text}"</p>
                        <div className="reviewer-info">
                            <h4>{review.name}</h4>
                            <p className="reviewer-role">{review.role}</p>
                        </div>
                    </div>
                ))}
            </div>
        </section>
    );
};

export default Reviews;
